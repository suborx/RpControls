# -*- encoding : utf-8 -*-

#class RpControl < Sinatra::Base

  get '/' do
    if @current_user.nil?
      redirect to '/new/inspiration/for_respondent'
    elsif @current_user.is_admin?
      redirect to '/users'
    else
      redirect to '/contacts'
    end
  end

  get '/login' do
    redirect to '/new/inspiration/for_respondent'
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
      flash.next[:warning] = "Kontrolor #{user.full_name} bol úspešne aktivovaný."
    elsif @current_user.is_admin? && user && params[:active] == 'false'
      user.deactivate!
      flash.next[:warning] = "Kontrolor #{user.full_name} bol úspešne deaktivovaný."
    else
      nil
    end
    redirect to '/users'
  end

#end
