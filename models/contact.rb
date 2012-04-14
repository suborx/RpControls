# -*- encoding : utf-8 -*-

class Contact < ActiveRecord::Base
  require_relative '../lib/extensions'
  include FormErrorHelper
  include PhoneNumberFormater

  attr_accessor :street, :number, :city

  has_many :controls
  belongs_to :branch
  belongs_to :address

  before_save :assign_address, :convert_phone_format

  validates_presence_of :first_name, :last_name, :phone, :branch_id, :street, :number, :city, :message => "povinná položka"

  delegate :name, :to => :branch, :prefix => true

  def full_name
    last_name + ' ' + first_name
  end

  private

  def assign_address
    a = Address.find_by_street_and_number(street, number)
    a = Address.new(:street => street, :number => number) unless a
    a.city = City.find_or_create_by_name(city)
    a.save
    self.address = a
  end
end
