require 'rubygems'
require 'em-websocket'
require 'yajl'
require 'sinatra/base'
require 'thin'
require 'pg'
require 'active_record'
require 'logger'
require 'pathname'

require 'erb'

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

require APP_ROOT.join('config', 'database')