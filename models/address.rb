# -*- encoding : utf-8 -*-

class Address < ActiveRecord::Base
  establish_connection 'local_db'
  has_many :contacts
  belongs_to :city
  validates_presence_of :street, :city, :message => "povinná položka"
  delegate :name, :to => :city, :prefix => true

  def complete_address
    "#{street} #{number}, #{city_name}"
  end
end
