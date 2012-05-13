# -*- encoding : utf-8 -*-

#class RpControl < Sinatra::Base

  get '/jobs' do
    @controls = Control.search(@current_user,params[:search]).uncontrolled.order(:id).paginate(:page =>params[:page], :per_page => 18).includes([:contact => :address,:user => :branch])
    haml :'jobs/index'
  end

  get '/new/job' do
    @control = Control.new
    haml :'jobs/new'
  end

  post '/jobs' do
    locations = params[:control].delete('locations')
    common_attributes = params[:control]
    @create_result = true
    if locations
      locations.each do |key,location|
        @control = Control.new
        @control.attributes = common_attributes.merge({
          :control_type => location[:control_type],
          :for_address => location[:for_address],
          :notice => location[:notice]
        })
        @create_result = @control.create_default_number_of_controls unless @create_result == false
      end
    else
      @control = Control.new(params[:control])
      @create_result = @control.create_default_number_of_controls
      @control.inspiration.update_attribute(:is_posted,true) if @create_result
    end


    if @create_result
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
