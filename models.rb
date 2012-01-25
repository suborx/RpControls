require 'sinatra/activerecord'

ActiveRecord::Base.configurations = {
  'local_db' => {
     'adapter' => 'mysql2',
     'encoding' => 'utf8',
     'host' => 'localhost',
     'username' => 'root',
     'password' => '',
     'database' => 'rpcontrol'
   },

  'remote_db' => {
    'adapter' => 'mysql2',
    'host' => '195.210.28.182',
    'username' => 'wordpress',
    'password' => 'AA@#zz235~#blazka',
    'database' => 'honeybee_production'
  }
 }

class PhoneRecord < ActiveRecord::Base
  establish_connection 'remote_db'
end

class Branch < ActiveRecord::Base
  establish_connection 'local_db'
  validates_presence_of :name
  has_many :users
end

class Contact < ActiveRecord::Base
  establish_connection 'local_db'
  has_many :controls
end

class Control < ActiveRecord::Base
  establish_connection 'local_db'
  belongs_to :user
  belongs_to :contact
end

class User < ActiveRecord::Base
  attr_accessor :password
  establish_connection 'local_db'
  has_many :controls
  belongs_to :branch
  before_save :encrypt_password

  validates_presence_of :email, :password, :first_name, :last_name, :phone, :branch_id
  validates_uniqueness_of :email
  validates_confirmation_of :password

  delegate :name, :to => :branch, :prefix => true

  def full_name
    first_name + ' ' + last_name
  end

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

end
