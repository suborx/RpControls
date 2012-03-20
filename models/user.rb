# -*- encoding : utf-8 -*-

class User < ActiveRecord::Base

  include FormErrorHelper
  include PhoneNumberFormater

  establish_connection 'local_db'

  attr_accessor :password

  has_many :controls
  belongs_to :branch, :include => :contacts

  before_create :encrypt_password
  before_save :convert_phone_format

  validates_presence_of :email, :first_name, :last_name, :phone, :branch_id, :message => "povinná položka"
  validates_uniqueness_of :email, :message => 'email už bol použitý'
  validates_presence_of :password, :if => "password_hash.blank?", :message => "povinná položka"
  validates_confirmation_of :password, :if => 'password_hash.blank?', :message => "nebolo potvrdené"

  scope :with_last_name, lambda { |last_name| where(["last_name LIKE ?", "#{last_name}%"])  }

  delegate :name, :to => :branch, :prefix => true

  def full_name; last_name + ' ' + first_name end

  def self.authenticate(email,password)
    user = find_by_email(email)
    if !user || !user.is_active?
      nil
    elsif user.is_active? &&  user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.search(search_query)
    search_query ? with_last_name(search_query) : order('is_active DESC')
  end

  def activate!
    update_attribute(:is_active, true)
  end

  def deactivate!
    update_attribute(:is_active, false)
  end

  def count_verified
    @count_verified ||= controls.to_a.count{|c| c.verified?}
  end

  def count_unverified
    @count_unverified ||= controls.to_a.count{|c| !c.verified?}
  end

end
