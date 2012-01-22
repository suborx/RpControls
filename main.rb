# -*- encoding : utf-8 -*-
require 'sinatra/activerecord'

ActiveRecord::Base.configurations = {
  'local_db' => {
     'adapter' => 'mysql2',
     'host' => 'localhost',
     'username' => 'root',
     'password' => '',
     'database' => 'rpcontrol'
   },

  'remote_db' => {
     'adapter' => 'mysql2',
     'host' => '195.210.28.182',
     'username' => 'wordpress',
     'password' => 'AA@#zz235~#blazka',
    'database' => 'honeybee_production'
  }
 }

class Branch < ActiveRecord::Base
  establish_connection 'local_db'
  validates_presence_of :name
  has_many :users
end

class User < ActiveRecord::Base
  attr_accessor :password
  establish_connection 'local_db'
  belongs_to :branch
  before_save :encrypt_password

  validates_presence_of :email, :password
  validates_uniqueness_of :email
  validates_confirmation_of :password

  def self.authenticate(email,password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end

class RpControl < Sinatra::Base

  configure do
    enable :sessions
    enable :method_override
    set :session_secret, "My session secret"
  end

  before do
    redirect to '/login' unless current_user || request.path == '/login'
  end

  helpers do
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end

  get '/' do
    haml :'branches/index'
  end

  get '/login' do
    haml :login, :layout => false
  end

  post '/login' do
    user = User.authenticate(params[:email], params[:password])
    session[:user_id] = user.id if user
    redirect to '/'
  end

  delete '/logout' do
    session[:user_id] = nil
    redirect to '/'
  end

  get '/new/user' do
    @title = 'Registrácia kontrolóra'
    haml :'users/new'
  end

  post '/users' do
    @user = User.new(params[:user])
    if @user.save
      redirect to '/'
    else
      redirect to '/new/user'
    end
  end

end
