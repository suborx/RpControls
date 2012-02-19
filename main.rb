# -*- encoding : utf-8 -*-
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/r18n'
require 'will_paginate'
require 'will_paginate/active_record'
include WillPaginate::Sinatra::Helpers

class RpControl < Sinatra::Base
  TIME_FORMAT = '%d. %m. %Y'

  configure do
    set :root, File.dirname(__FILE__)
    set :locales, File.join(File.dirname(__FILE__), 'i18n/sk.yml')
    set :default_locale, 'sk'
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

  helpers do

    def paginate_labels
      {:previous_label => '<<', :next_label => '>>'}
    end

    def is_current_path?(path)
      request.path == path ? 'active' : ''
    end

    def boolean_label_for(state,conditions={})
      if conditions.key?(:represented_if) && !conditions[:represented_if]
        '<span class="label">N/A</span>'
      elsif state
        '<span class="label label-success">ANO</span>'
      else
        '<span class="label label-important">NIE</span>'
      end
    end

    def flash_messages
      return if flash.empty?
      if flash.key?(:error)
        html_class = "alert-error"
        html_message = flash[:error]
      else
        html_class = "alert-success"
        html_message = flash[:success]
      end

      "<div class='alert #{html_class}'>
        <a class='close'>x</a>
        #{html_message}
      </div>"
    end
  end

  get '/' do
    if @current_user.is_admin?
      redirect to '/users'
    else
      redirect to '/contacts'
    end
  end

  get '/login' do
    haml :login, :layout => false
  end

  post '/login' do
    user = User.authenticate(params[:email], params[:password])
    session[:current_user] = user if user
    redirect to '/'
  end

  delete '/logout' do
    session[:current_user] = nil
    redirect to '/'
  end

  put '/users/activation' do
    user = User.find(params[:user_id])
    if @current_user.is_admin? && user && params[:active] == 'true'
      user.activate!
      flash.next[:success] = "Kontrolor #{user.full_name} bol úspešne aktivovaný."
    elsif @current_user.is_admin? && user && params[:active] == 'false'
      user.deactivate!
      flash.next[:success] = "Kontrolor #{user.full_name} bol úspešne deaktivovaný."
    else
      nil
    end
    redirect to '/users'
  end

##### USER RESOURCE #####

  get '/users' do
    @users = User.order('is_active DESC').paginate(:page =>params[:page], :per_page => 10).includes([:controls, :branch => :contacts,])
    haml :'users/index'
  end

  get '/users/:id' do
    @user = User.includes(:controls).find(params[:id])
    @controls = @user.controls.paginate(:page =>params[:page], :per_page => 10)
    haml :'users/show'
  end

  get '/new/user' do
    haml :'users/new'
  end

  post '/users' do
    @user = User.new(params[:user])
    if @user.save
      flash.next[:success] = 'Registrácia nového kontrolóra bola úspešná.'
      redirect to '/users'
    else
      flash.now[:error] = 'Registrácia bola neuspešná.'
      haml :'users/new'
    end
  end

  get '/edit/users/:id' do
    @user = User.find(params[:id])
    haml :'users/edit'
  end

  put '/users/:id' do
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash.next[:success] = 'Úprava kontrolóra prebehla úspešne.'
      redirect to '/users'
    else
      flash.now[:error] = 'Úprava kontrolóra nebola úspešná.'
      haml :'users/edit'
    end
  end

##### CONTROLS RESOURCE #####

  get '/controls' do
    @controls = if @current_user.is_admin?
      Control.paginate(:page =>params[:page], :per_page => 18).includes([:contact,:user => :branch])
    else
      @current_user.controls
    end
    haml :'controls/index'
  end

  get '/control/:id' do
  end

  get '/new/control' do
    haml :'controls/new'
  end

  post '/controls' do
    @control = @current_user.controls.new(params[:control])
    if @control.save
      flash.next[:success] = 'Pridanie kontroly prebehlo úspešne.'
      redirect to '/controls'
    else
      flash.now[:error] = 'Pridanie kontroly bolo neúspešné.'
      haml :'controls/new'
    end
  end

  get '/edit/control/:id' do
  end

  put '/controls' do
  end

  delete '/control/:id' do
  end

##### CONTACT RESOURCE #####

  get '/contacts' do
    @contacts = if @current_user.is_admin?
      Contact.paginate(:page =>params[:page], :per_page => 18).includes([{:address => :city},:controls, :branch]).order('created_at DESC')
    else
      @current_user.branch.contacts.order('created_at DESC')
    end
    haml :'contacts/index'
  end

  get '/contacts/:id' do
    @contact = Contact.includes(:controls).find(params[:id])
    @controls = @contact.controls.paginate(:page =>params[:page], :per_page => 18).includes(:user)
    haml :'contacts/show'
  end

  get '/new/contact' do
    haml :'contacts/new'
  end

  post '/contacts' do
    @contact = Contact.new(params[:contact])
    if @contact.save
      flash.next[:success] = 'Registrácia respondenta prebehla úspešne.'
      redirect to '/contacts'
    else
      flash.now[:error] = 'Registrácia respondenta nebola úspešná.'
      haml :'contacts/new'
    end
  end

  get '/edit/contacts/:id' do
    @contact = Contact.find(params[:id])
    haml :'contacts/edit'
  end

  put '/contacts/:id' do
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(params[:contact])
      flash.next[:success] = 'Úprava respondenta prebehla úspešne.'
      redirect to '/contacts'
    else
      flash.now[:error] = 'Úprava respondenta nebola úspešná.'
      haml :'contacts/edit'
    end
  end

  delete '/contact/:id' do
  end

end
