# -*- encoding : utf-8 -*-
require 'sinatra/activerecord'

class RpControl < Sinatra::Base

  configure do
    enable :sessions
    enable :method_override
    set :session_secret, "My session secret"
  end

  before do
    if session[:current_user]
      @current_user = session[:current_user]
    elsif request.path != '/login'
      redirect to '/login'
    end
  end

  helpers do

    #def current_user
      #@current_user = if session[:current_user]
        #session[:current_user]
      #elsif session[:user_id]
        #User.find(session[:user_id])
      #end
    #end

    def is_current_path?(path)
      request.path == path ? 'active' : ''
    end

    def boolean_label_for(state)
      if state
        '<span class="label label-success">ANO</span>'
      else
        '<span class="label label-important">NIE</span>'
      end
    end
  end

  get '/' do
    redirect to '/contacts'
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
    elsif @current_user.is_admin? && user && params[:active] == 'false'
      user.deactivate!
    else
      nil
    end
    redirect to '/users'
  end

##### USER RESOURCE #####

  get '/users' do
    @users = User.includes([:controls, :branch => :contacts,])
    haml :'users/index'
  end

  get '/user/:id' do
    @user = User.find(:id)
  end

  get '/new/user' do
    haml :'users/new'
  end

  post '/users' do
    @user = User.new(params[:user])
    redirect to @user.save ? '/' : '/new/user'
  end

  get '/edit/user/:id' do
    @user = User.find(:id)
  end

  put '/users' do
    @user = User.find(:id)
    @user.update_attributes(params[:user])
  end

##### CONTROLS RESOURCE #####

  get '/controls' do
    @controls = if @current_user.is_admin?
      Control.includes([:contact,:user => :branch])
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
      redirect to '/controls'
    else
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
      Contact.includes(:controls, :branch)
    else
      @current_user.branch.contacts
    end
    haml :'contacts/index'
  end

  get '/contact/:id' do
  end

  get '/new/contact' do
    haml :'contacts/new'
  end

  post '/contacts' do
    @contact = Contact.new(params[:contact])
    if @contact.save
      redirect to '/contacts'
    else
      haml :'contacts/new'
    end
  end

  get '/edit/contact/:id' do
  end

  put '/contacts' do
  end

  delete '/contact/:id' do
  end

end
