# -*- encoding : utf-8 -*-
module FormErrorHelper

  def flash_error_for(attr)
    errors[attr].first
  end

  def has_error_on?(attr)
    !errors[attr].empty? ? 'error' : ''
  end

end

module PhoneNumberFormater

  def convert_phone_format
    phone.gsub!(/\s/,'')
    phone.gsub!(/\A\+421/,'')
    phone.gsub!(/\D/,'')
    phone.gsub!(/\A00421/,'')
    phone.gsub!(/\A0/,'')
    phone.insert(0,'+421')
  end

end

class PhoneRecord < ActiveRecord::Base
  establish_connection 'remote_db'
end

class Branch < ActiveRecord::Base
  establish_connection 'local_db'
  validates_presence_of :name, :message => "povinná položka"
  has_many :users
  has_many :contacts

  scope :with_users, joins('LEFT JOIN users ON users.branch_id = branches.id').where('users.branch_id = branches.id').uniq

  def actual_controlor
    users.where(:is_active => true).last
  end
end

class Control < ActiveRecord::Base
  include FormErrorHelper
  establish_connection 'local_db'
  belongs_to :user
  belongs_to :contact

  validates_presence_of :contact_id, :if => 'was_controlled', :message => "povinná položka"
  validates_presence_of :control_date, :if => 'was_controlled', :message => "povinná položka"
  validates_presence_of :user_id, :for_week, :for_address, :control_type, :message => "povinná položka"

  scope :with_contact_last_name, lambda { |contact_last_name| joins(:contact).where(["contacts.last_name LIKE ?", "#{contact_last_name}%"]) }
  scope :controlled, where(:was_controlled => true)
  scope :uncontrolled, where(:was_controlled => false)

  default_scope(order('created_at DESC'))


  def self.search(user,search_query=nil)
    if user.is_admin?
      search_query ? with_contact_last_name(search_query) : self
    else
      controls =  where(:user_id => user.id)
      search_query ? controls.with_contact_last_name(search_query) : controls
    end
  end

  def self.find_related_controls(group_id)
    where(:group_id => group_id)
  end

  def current_week
    d = DateTime.parse(created_at.to_s)
    d.cweek
  end

  def create_default_number_of_controls
    return false unless save
    update_attributes(:group_id => id)
    (RpControl::DEFAULT_NUMBER_OF_CONTROLS - 1).times do
      control_dup = self.dup
      control_dup.save
    end
  end

  def update_related_controls(params)
    related_controls = Control.find_related_controls(group_id)
    related_controls.each{ |c| @valid = c.update_attributes(params)}
    update_attributes(params) unless @valid
    @valid
  end

end

class User < ActiveRecord::Base
  include FormErrorHelper
  include PhoneNumberFormater
  attr_accessor :password
  establish_connection 'local_db'
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

class Contact < ActiveRecord::Base
  include FormErrorHelper
  include PhoneNumberFormater
  establish_connection 'local_db'
  attr_accessor :street, :number, :city
  has_many :controls
  belongs_to :branch
  belongs_to :address
  delegate :name, :to => :branch, :prefix => true
  validates_presence_of :first_name, :last_name, :phone, :branch_id, :street, :number, :city, :message => "povinná položka"
  before_save :assign_address, :convert_phone_format

  def full_name; last_name + ' ' + first_name end

  private

  def assign_address
    a = Address.find_by_street_and_number(street, number)
    a = Address.new(:street => street, :number => number) unless a
    a.city = City.find_or_create_by_name(city)
    a.save
    self.address = a
  end
end

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

class City < ActiveRecord::Base
  establish_connection 'local_db'
  has_many :addresses
  validates_presence_of :name, :message => "povinná položka"
end

