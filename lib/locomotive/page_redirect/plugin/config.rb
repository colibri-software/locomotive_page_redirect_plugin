module Locomotive
  module PageRedirect
    class Config
      def self.hash=(hash)
        @@config_hash = ConfigObject.new(hash)
      end
      def self.hash
        @@config_hash ||= ConfigObject.new
      end
    end
    class ConfigObject < Hash
      def initialize(hash = {})
        defaults = {
          redirect_model_slug: nil,
          regexp_field_slug: 'regexp',
          url_field_slug: 'url',
        }
        merge!(defaults)
        hash.select! {|k,v| v && (v.class != String || !v.empty?)}
        merge!(hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo})
      end
    end
  end
end
