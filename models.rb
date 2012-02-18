class PhoneRecord < ActiveRecord::Base
  establish_connection 'remote_db'
end

class Branch < ActiveRecord::Base
  establish_connection 'local_db'
  validates_presence_of :name
  has_many :users
  has_many :contacts
end

class Contact < ActiveRecord::Base
  establish_connection 'local_db'
  attr_accessor :street, :number, :city
  has_many :controls
  belongs_to :branch
  belongs_to :address
  delegate :name, :to => :branch, :prefix => true
  validates_presence_of :first_name, :last_name, :phone, :branch_id, :street, :number, :city
  before_save :assign_address

  def full_name; first_name + ' ' + last_name end

  private

  def assign_address
    a = Address.find_by_street_and_number(street, number)
    a = Address.new(:street => street, :number => number) unless address
    a.city = City.find_or_create_by_name(city)
    a.save
    self.address = a
  end
end

class Control < ActiveRecord::Base
  establish_connection 'local_db'
  belongs_to :user
  belongs_to :contact
  validates_presence_of :contact_id, :user_id
end

class User < ActiveRecord::Base
  attr_accessor :password
  establish_connection 'local_db'
  has_many :controls
  belongs_to :branch, :include => :contacts
  before_save :encrypt_password

  validates_presence_of :email, :password, :first_name, :last_name, :phone, :branch_id
  validates_uniqueness_of :email
  validates_confirmation_of :password

  delegate :name, :to => :branch, :prefix => true

  def full_name; first_name + ' ' + last_name end

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

class Address < ActiveRecord::Base
  establish_connection 'local_db'
  has_many :contacts
  belongs_to :city
  validates_presence_of :street, :city
  delegate :name, :to => :city, :prefix => true
  def complete_address
    "#{street} #{number}, #{city_name}"
  end
end

class City < ActiveRecord::Base
  establish_connection 'local_db'
  has_many :addresses
  validates_presence_of :name
end
