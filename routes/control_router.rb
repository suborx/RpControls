# -*- encoding : utf-8 -*-

class RpControl < Sinatra::Base

  get '/controls' do
    @controls = Control.search(@current_user,params[:search]).controlled.paginate(:page =>params[:page], :per_page => 18).includes([:contact => :address,:user => :branch])
    haml :'controls/index'
  end

  get '/control/:id' do
  end

  get '/new/control' do
    @control = Control.new
    haml :'controls/new'
  end

  get '/new/control/:contact_id' do
    @control = Control.new
    @contact = Contact.find params[:contact_id]
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

  get '/edit/controls/:id' do
    @control = Control.find(params[:id])
    haml :'controls/edit'
  end

  put '/controls/:id' do
    @control = Control.find(params[:id])
    if @control.update_attributes(params[:control])
      flash.next[:success] = 'Úprava kontroly prebehla úspešne.'
      redirect to '/controls'
    else
      flash.now[:error] = 'Úprava kontroly nebola úspešná.'
      haml :'controls/edit'
    end
  end

end
