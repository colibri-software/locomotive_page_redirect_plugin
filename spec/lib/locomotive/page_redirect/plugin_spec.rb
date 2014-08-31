require 'spec_helper'

module Locomotive
  module PageRedirect
    describe Plugin do
      before :each do
        @type = FactoryGirl.build(:content_type)
        @type.entries_custom_fields.build(label: 'regexp', type: 'string')
        @type.entries_custom_fields.build(label: 'url', type: 'string')
        @type.save
        @site = @type.site
        Locomotive::Plugins.use_site(@site)
        @plugin = Plugin.new()
        Config.hash = {
          redirect_model_slug: @type.slug
        }
      end
      it 'should not redirect pages not in the model' do
        @type.entries.create(regexp: '/bad-path', url: 'nowhere')
        controller = FakeController.new
        request = FakeRequest.new
        request.fullpath = '/good-path'
        controller.request = request
        controller.current_site = @site
        @plugin.expects(:controller).twice.returns(controller)
        @plugin.expects(:redirect_to).never
        @plugin.run_callbacks(:page_render)
      end
      it 'should redirect pages in the model' do
        @type.entries.create(regexp: '/bad-path', url: 'somewhere')
        controller = FakeController.new
        request = FakeRequest.new
        request.fullpath = '/bad-path'
        controller.request = request
        controller.current_site = @site
        controller.expects(:redirect_to).once.with('somewhere')
        @plugin.expects(:controller).at_least_once.returns(controller)
        @plugin.run_callbacks(:page_render)

      end
    end
    class FakeController
      def initialize()
        @session = {}
        @flash = {}
      end
      attr_accessor :request, :current_site
    end
    class FakeRequest
      attr_accessor :fullpath
    end
  end
end
