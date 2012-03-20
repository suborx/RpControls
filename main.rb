# -*- encoding : utf-8 -*-
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/r18n'
require 'will_paginate'
require 'will_paginate/active_record'
include WillPaginate::Sinatra::Helpers

class RpControl < Sinatra::Base

  DEFAULT_NUMBER_OF_CONTROLS = 3
  TIME_FORMAT = '%d. %m. %Y'

  configure do
    set :root, File.dirname(__FILE__)
    #set :locales, File.join(File.dirname(__FILE__), 'i18n/sk.yml')
    #set :default_locale, 'sk'
    set :show_exceptions, true
    set :session_secret, "My session secret"
    register Sinatra::Flash
    register Sinatra::Reloader
    register Sinatra::R18n
    enable :sessions
    enable :method_override
  end

  before do
    if session[:current_user]
      @current_user = session[:current_user]
    elsif request.path != '/login'
      redirect to '/login'
    end
  end


end

require_relative 'models/init'
require_relative 'routes/init'
require_relative 'helpers/application_helper'

