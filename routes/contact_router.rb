# -*- encoding : utf-8 -*-

#class RpControl < Sinatra::Base

  get '/contacts' do
    @contacts = if @current_user.is_admin?
      Contact.paginate(:page =>params[:page], :per_page => 18).includes([{:address => :city},:controls, :branch]).order('last_name')
    else
      @current_user.branch.contacts.paginate(:page =>params[:page], :per_page => 18).includes([{:address => :city},:controls, :branch]).order('created_at DESC')
    end
    haml :'contacts/index'
  end

  get '/contacts/:id' do
    @contact = Contact.includes(:controls).find(params[:id])
    @controls = @contact.controls.paginate(:page =>params[:page], :per_page => 18).includes(:user)
    haml :'contacts/show'
  end

  get '/new/contact' do
    @contact = Contact.new
    haml :'contacts/new'
  end

  post '/contacts' do
    if @current_user.is_admin?
      @contact = Contact.new(params[:contact])
    else
      @contact = @current_user.branch.contacts.new(params[:contact])
    end
    if @contact.save
      flash.next[:success] = 'Registrácia respondenta prebehla úspešne.'
      redirect to '/contacts'
    else
      flash.now[:error] = 'Registrácia respondenta nebola úspešná.'
      haml :'contacts/new'
    end
  end

  get '/edit/contacts/:id' do
    @contact = Contact.find(params[:id])
    haml :'contacts/edit'
  end

  put '/contacts/:id' do
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(params[:contact])
      flash.next[:success] = 'Úprava respondenta prebehla úspešne.'
      redirect to '/contacts'
    else
      flash.now[:error] = 'Úprava respondenta nebola úspešná.'
      haml :'contacts/edit'
    end
  end

  delete '/contact/:id' do
  end

  get '/contacts_for_control/:id' do
    @contact = Contact.includes(:controls).find(params[:id])
    @controls = @contact.controls.paginate(:page =>params[:page], :per_page => 18).includes(:user)
    haml :'contacts/show_for_js', :layout => false
  end

#end
