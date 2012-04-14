# -*- encoding : utf-8 -*-

class PhoneRecord < ActiveRecord::Base

  establish_connection Sinatra::Application::DB_CONFIG['remote_db']

end
