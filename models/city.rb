# -*- encoding : utf-8 -*-

class City < ActiveRecord::Base
  establish_connection 'local_db'
  has_many :addresses
  validates_presence_of :name, :message => "povinná položka"
end
