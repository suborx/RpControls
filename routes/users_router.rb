# -*- encoding : utf-8 -*-

class RpControl < Sinatra::Base

  get '/users' do
    @users = User.search(params[:search]).paginate(:page =>params[:page], :per_page => 10).includes([:controls, :branch => :contacts])
    haml :'users/index'
  end

  get '/users/:id' do
    @user = User.includes(:controls).find(params[:id])
    @controls = @user.controls.controlled.paginate(:page =>params[:page], :per_page => 10).includes(:contact => {:address => :city})
    haml :'users/show'
  end

  get '/new/user' do
    @user = User.new
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

end
