require 'locomotive_plugins'
require 'locomotive/page_redirect/plugin/config'

module Locomotive
  module PageRedirect
    class Plugin
      include Locomotive::Plugin

      after_plugin_setup :set_config
      before_page_render :redirect

      def config_template_file
        File.join(File.dirname(__FILE__), 'plugin', 'config.haml')
      end

      protected

      def set_config
        Config.hash = config
      end

      # gets the current site
      def get_site
        controller.send(:current_site)
      end

      # gets the model and it needs for the redirects
      def get_model(model_slug)
        site = get_site
        site.content_types.where(:slug => model_slug).first
      end

      # loops through all the redirect entries from the given model
      # and checks if the fullpath match the regex given and will
      # redirect to the given url.
      def redirect
        redirect_model = get_model(Config.hash[:redirect_model_slug])
        if redirect_model
          redirect_model.entries.each do |entry|
            regexp = entry.send(Config.hash[:regexp_field_slug])
            redirect_url = entry.send(Config.hash[:url_field_slug])
            if controller.request.fullpath =~ /#{regexp}/
              regexp_data = /#{regexp}/.match(controller.request.fullpath)
              /#{regexp}/.named_captures.each do |key,value|
              redirect_url.gsub!(/\$#{key}/, regexp_data[key])
              end
            controller.redirect_to redirect_url and return
            end
          end
        end
      end
    end
  end
end
