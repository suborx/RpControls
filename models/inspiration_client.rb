# -*- encoding : utf-8 -*-

class InspirationClient < ActiveRecord::Base
  has_many :inspirations
  validates_presence_of :name, :ico, :phone, :contact_person
end
