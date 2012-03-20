# -*- encoding : utf-8 -*-

class PhoneRecord < ActiveRecord::Base

  establish_connection 'remote_db'

end
