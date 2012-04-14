# -*- encoding : utf-8 -*-

class City < ActiveRecord::Base
  has_many :addresses
  validates_presence_of :name, :message => "povinná položka"
end
