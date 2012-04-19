# -*- encoding : utf-8 -*-

class Inspiration < ActiveRecord::Base

  belongs_to :week
  belongs_to :contact
  has_many :inspiration_addresses
  has_many :inspiration_clients

end

