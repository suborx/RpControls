# -*- encoding : utf-8 -*-

#class RpControl < Sinatra::Base

  get '/jobs' do
    @controls = Control.search(@current_user,params[:search]).uncontrolled.paginate(:page =>params[:page], :per_page => 18).includes([:contact => :address,:user => :branch])
    haml :'jobs/index'
  end

  get '/new/job' do
    @control = Control.new
    haml :'jobs/new'
  end

  post '/jobs' do
    @control = Control.new(params[:control])
    if @control.create_default_number_of_controls
      flash.next[:success] = 'Pridanie kontroly prebehlo úspešne.'
      redirect to '/jobs'
    else
      flash.now[:error] = 'Pridanie kontroly bolo neúspešné.'
      haml :'jobs/new'
    end
  end

  get '/edit/jobs/:id' do
    @control = Control.find(params[:id])
    haml :'jobs/edit'
  end

  put '/jobs/:id' do
    @control = Control.find(params[:id])
    if @control.update_related_controls(params[:control])
      flash.next[:success] = 'Úprava kontroly prebehla úspešne.'
      redirect to '/jobs'
    else
      flash.now[:error] = 'Úprava kontroly nebola úspešná.'
      haml :'jobs/edit'
    end
  end

  delete '/jobs/:id' do
    c = Control.find(params[:id])
    c.destroy unless c.was_controlled
    redirect to '/jobs'
  end
#end
