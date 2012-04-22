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
      redirect to "/inspirations/#{@inspiration.id}"
    else
      flash.now[:error] = 'Ľutujeme váš podnet nebol pridaný.'
      haml :'inspirations/new_for_respondent', :layout => :login
    end
  end

  post '/inspirations/from_client' do
    @inspiration = Inspiration.new(params[:inspiration])
    if @inspiration.save
      flash.next[:success] = 'Váš podnet na kontrolu bol úspešne pridaný.'
      redirect to "/inspirations/#{@inspiration.id}"
    else
      debugger
      flash.now[:error] = 'Ľutujeme váš podnet nebol pridaný.'
      haml :'inspirations/new_for_client', :layout => :login
    end
  end

  get '/edit/inspirations/:id' do
    @inspiration = Inspiration.find(params[:id])
    haml :'inspirations/edit'
  end

  put '/users/:id' do
    @inspiration = Inspiration.find(params[:id])
    if @inspiration.update_attributes(params[:inspiration])
      flash.next[:success] = 'Úprava podnetu prebehla úspešne.'
      redirect to '/inspirations'
    else
      flash.now[:error] = 'Úprava podnetu nebola úspešná.'
      haml :'inspirations/edit'
    end
  end
