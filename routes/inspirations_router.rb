# -*- encoding : utf-8 -*-

  get '/inspirations' do
    @inspirations = Inspiration.all
    haml :'inspirations/index'
  end

  get '/users/:id' do
    @inspiration = Inspiration.find(params[:id])
    haml :'inspirations/show'
  end

  get '/new/user' do
    @inspiration = Inspiration.new
    haml :'inspirations/new'
  end

  post '/inspirations/from_respondent' do
    params.inspect
    #@inspiration = Inspiration.new(params[:inspiration])
    #if @inspiration.save
      #flash.next[:success] = 'Váš podnet na kontrolu bol úspešne pridaný.'
      #redirect to '/inspirations'
    #else
      #flash.now[:error] = 'Ľutujeme váš podnet nebol pridaný.'
      #haml :'inspirations/new'
    #end
  end

  post '/inspirations/from_client' do
    params.inspect
    #@inspiration = Inspiration.new(params[:inspiration])
    #if @inspiration.save
      #flash.next[:success] = 'Váš podnet na kontrolu bol úspešne pridaný.'
      #redirect to '/inspirations'
    #else
      #flash.now[:error] = 'Ľutujeme váš podnet nebol pridaný.'
      #haml :'inspirations/new'
    #end
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
