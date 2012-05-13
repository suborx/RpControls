# -*- encoding : utf-8 -*-

  get '/inspirations' do
    @inspirations = Inspiration.all
    haml :'inspirations/index'
  end

  get '/inspirations/:id' do
    @inspiration = Inspiration.find(params[:id])
    haml :'inspirations/show', :layout => :login
  end

  get '/new/inspiration/for_respondent' do
    @inspiration = Inspiration.new
    haml :'inspirations/new_for_respondent', :layout => :login
  end

  get '/new/inspiration/for_client' do
    @inspiration = Inspiration.new
    @inspiration.inspiration_client_attributes = {}
    haml :'inspirations/new_for_client', :layout => :login
  end

  post '/inspirations/from_respondent' do
    @inspiration = Inspiration.new(params[:inspiration])
   if @inspiration.save
      flash.next[:success] = 'Váš podnet na kontrolu bol úspešne pridaný.'
      redirect to "/new/inspiration/for_respondent"
    else
      flash.now[:error] = 'Ľutujeme váš podnet nebol pridaný.'
      haml :'inspirations/new_for_respondent', :layout => :login
    end
  end

  post '/inspirations/from_client' do
    @inspiration = Inspiration.new(params[:inspiration])
    if @inspiration.save
      flash.next[:success] = 'Váš podnet na kontrolu bol úspešne pridaný.'
      redirect to "/new/inspiration/for_client"
    else
      flash.now[:error] = 'Ľutujeme váš podnet nebol pridaný.'
      haml :'inspirations/new_for_client', :layout => :login
    end
  end

  get '/inspirations/:id/prepare_job_for_respondent' do
    inspiration = Inspiration.find params[:id]
    if inspiration && inspiration.week.branch.actual_controlor
      @control = Control.initialize_from_inspiration(params[:id])
      haml :'jobs/edit'
    else
      flash.next[:error] = 'Ľutujeme no pre zadanú redakciu nemáte prideleného kontrolóra'
      redirect to '/inspirations'
    end
  end

  get '/inspirations/:id/prepare_job_for_client'do
    @inspiration = Inspiration.find params[:id]
    haml :'inspirations/prepare_job_for_client'
  end

  post '/inspirations/create_job_for_client'do
    @inspiration = Inspiration.find(params[:inspiration][:id])
    @control = Control.create_job_from_client_inspiration(params[:inspiration])
    if @control
      @inspiration.inspiration_addresses.where(:id => params[:inspiration][:inspiration_address_ids]).each do |address|
        address.update_attribute(:is_assigned,true)
      end
      @inspiration.update_attribute(:is_posted,true) if @inspiration.inspiration_addresses.empty?
      redirect to :'/jobs'
    else
      haml :'inspirations/prepare_job_for_client'
    end
  end


  #get '/edit/inspirations/:id' do
    #@inspiration = Inspiration.find(params[:id])
    #haml :'inspirations/edit'
  #end

  #put '/users/:id' do
    #@inspiration = Inspiration.find(params[:id])
    #if @inspiration.update_attributes(params[:inspiration])
      #flash.next[:success] = 'Úprava podnetu prebehla úspešne.'
      #redirect to '/inspirations'
    #else
      #flash.now[:error] = 'Úprava podnetu nebola úspešná.'
      #haml :'inspirations/edit'
    #end
  #end

  get '/inspirations/:id/destroy' do
    @inspiration = Inspiration.find(params[:id])
    @inspiration.destroy if @inspiration
    redirect to '/inspirations'
  end
