# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'page_redirect_plugin/version'


Gem::Specification.new do |s|

  s.name        = 'locomotive_page_redirect_plugin'
  s.version     = PageRedirectPlugin::VERSION
  s.date        = '2013-04-24'
  s.summary     = "Locomotive CMS plugin for page redirection"
  s.description = "Allows CMS designers to assign a locomotive model that defines page redirestions."
  s.authors     = ["Colibri Software Inc."]
  s.email       = 'info@colibri-software.com'

  s.add_dependency "locomotive_plugins", '~> 1.0'

  s.files       = `git ls-files`.split($/)
  s.homepage    = 'http://colibri-software.com'
  s.require_paths = ['lib']
end


