# -*- encoding : utf-8 -*-

class InspirationClient < ActiveRecord::Base
  has_many :inspirations
  validates_presence_of :name, :ico, :phone, :contact_person, :message => "povinná položka"

  def has_valid_attributes?(given_attributes)
    self.attributes = given_attributes
    valid?
  end
end
