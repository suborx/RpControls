# -*- encoding : utf-8 -*-

class Inspiration < ActiveRecord::Base

  require_relative '../lib/extensions'
  include FormErrorHelper

  attr_accessor :week_attributes, :contact_attributes, :inspiration_client_attributes, :inspiration_address_attributes

  belongs_to :week
  belongs_to :contact
  belongs_to :inspiration_client
  has_many :inspiration_addresses, :dependent => :destroy

  before_validation :assign_week, :assign_client, :validate_addresses
  after_validation :check_errors
  after_save :assign_addresses

  validates_presence_of :description

  accepts_nested_attributes_for :contact, :reject_if => proc{ |attributes| attributes.blank? }

  delegate :branch, :to => :week

  def valid_inspiration_address_attributes
    inspiration_address_attributes.reject{|key,value| value[:address].blank?}
  end

  private

  def assign_week
    attrs = { :branch_id => contact.try(:branch_id), :week => (week_attributes.present? ? week_attributes[:week_date] : Week.current_week_date{ |week_number| week_number - 1})}
    self.week = Week.find_or_create_week(attrs)
    if week.errors.any?
      assign_associated_errors(week.errors, :prefix => 'week.')
    end
  end

  def assign_client
    return if inspiration_client_attributes.nil?
    if client = prepare_client_for_assign
      self.inspiration_client = client
    end
  end


  def prepare_client_for_assign
    if client = InspirationClient.find_by_ico(inspiration_client_attributes[:ico])
      update_existing_inspiration_client(client)
    else
      create_new_inspiration_client
    end
  end

  def update_existing_inspiration_client(client)
    if client.has_valid_attributes?(inspiration_client_attributes)
      client.update_attributes(inspiration_client_attributes)
      client
    else
      assign_associated_errors(client.errors, :prefix => 'inspiration_client.')
    end
  end

  def create_new_inspiration_client
    client = InspirationClient.new(inspiration_client_attributes)
    assign_associated_errors(client.errors, :prefix => 'inspiration_client.') unless client.save
    client
  end

  def validate_addresses
    return if inspiration_address_attributes.nil?
    saved_records = inspiration_address_attributes.inject(0) do |result,pair|
      key, value = pair
      if value[:address].blank? || value[:control_type].blank?
        inspiration_address_attributes.delete( :key )
      else
        result =+ 1
      end
      result
    end
    errors[:'inspiration_address.address'] << 'povinná položka' if saved_records.zero?
  end

  def check_errors
    return false if errors.any?
  end

  def assign_addresses
    return if inspiration_address_attributes.nil?
    inspiration_address_attributes.each do |key,value|
      self.inspiration_addresses << InspirationAddress.create(value)
    end
  end
end

