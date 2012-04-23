# -*- encoding : utf-8 -*-

class Inspiration < ActiveRecord::Base

  require_relative '../lib/extensions'
  include FormErrorHelper

  attr_accessor :week_attributes, :contact_attributes, :inspiration_client_attributes, :inspiration_address_attributes

  belongs_to :week
  belongs_to :contact
  belongs_to :inspiration_client
  has_many :inspiration_addresses, :dependent => :destroy

  before_validation :assign_week, :assign_client
  after_save :assign_addresses

  validates_presence_of :description, :week

  accepts_nested_attributes_for :contact, :reject_if => proc{ |attributes| attributes.blank? }

  private

  def assign_week
    attrs = { :branch_id => contact.try(:branch_id), :week => (week_attributes.present? ? week_attributes[:week_date] : Week.current_week_date{ |week_number| week_number - 1})}
    self.week = Week.find_or_create_week(attrs)
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
    else
      assign_associated_errors(client.errors, :prefix => 'inspiration_client.')
      return nil
    end
  end

  def create_new_inspiration_client
    client = InspirationClient.new(inspiration_client_attributes)
    unless client.save
      assign_associated_errors(client.errors, :prefix => 'inspiration_client.')
      return nil
    end
    client
  end

  def assign_addresses
    return if inspiration_address_attributes.nil?
    saved_records = inspiration_address_attributes.inject(0) do |result,key, value|
      next if value[:address].blank? || value[:control_type].blank?
      self.inspiration_addresses << InspirationAddress.create(value)
      result =+ 1
    end
    debugger
    return false if saved_records.zero?
  end
end

