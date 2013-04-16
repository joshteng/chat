ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

require 'rubygems'
require 'em-websocket'
require 'yajl'
require 'sinatra'
require 'sinatra/base'
require 'thin'
require 'pg'
require 'active_record'
require 'logger'
require 'pathname'

require 'erb'

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

require APP_ROOT.join('config', 'database')
