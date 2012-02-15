ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'rubygems'
require 'bundler'

$: << Bundler.load.specs.find{|s| s.name == 'hashbang' }.full_gem_path + '/lib'

require 'hashbang'
require 'hashbang/standalone/middleware'

run Hashbang::Standalone::Middleware.new(File.expand_path('..',  __FILE__))