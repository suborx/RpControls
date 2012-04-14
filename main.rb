# -*- encoding : utf-8 -*-
#
ENV["RACK_ENV"] ||= "development"
puts "Environment: #{ENV["RACK_ENV"]}"

require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

require 'sinatra'
require 'haml'
require 'active_record'

#require 'sinatra/reloader'
#require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/r18n'
require 'will_paginate'
require 'will_paginate/active_record'
include WillPaginate::Sinatra::Helpers

#class RpControl < Sinatra::Base

  DEFAULT_NUMBER_OF_CONTROLS = 3
  TIME_FORMAT = '%d. %m. %Y'
  DB_CONFIG = YAML.load(File.read('config/database.yml'))

  # Database
  ActiveRecord::Base.establish_connection DB_CONFIG["#{settings.environment}"]

 #configure do
   #enable :sessions
   #enable :method_override
   #set :views, "#{File.dirname(__FILE__)}/views"
   #set :public, "#{File.dirname(__FILE__)}/public"
   #set :haml, :format => :html5
 #end

  configure do
    set :root, File.dirname(__FILE__)
    disable :run
    enable :method_override
    enable :sessions
    #set :locales, File.join(File.dirname(__FILE__), 'i18n/sk.yml')
    #set :default_locale, 'sk'
    set :show_exceptions, true
    set :session_secret, "My session secret"
    #register Sinatra::Flash
    #register Sinatra::Reloader
    #register Sinatra::R18n
  end

  configure :production do
    disable :logging
  end

  configure :development do
    enable :logging
    enable :show_exceptions
  end

  configure :test do
    enable :raise_errors
    disable :logging
    disable :reload_templates
  end



  before do
    if session[:current_user]
      @current_user = session[:current_user]
    elsif request.path != '/login'
      redirect to '/login'
    end
  end

#end

# Helpers
 Dir["#{File.dirname(__FILE__)}/helpers/**/*.rb"].each { |f| require f }

# # Models
 Dir["#{File.dirname(__FILE__)}/models/**/*.rb"].each { |f| require f }

# Routes
 Dir["#{File.dirname(__FILE__)}/routes/**/*.rb"].each { |f| require f }
