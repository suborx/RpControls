# -*- encoding : utf-8 -*-

class Branch < ActiveRecord::Base

  establish_connection 'local_db'

  has_many :users
  has_many :contacts

  validates_presence_of :name, :message => "povinná položka"

  scope :with_active_users, joins('LEFT JOIN users ON users.branch_id = branches.id').where('users.branch_id = branches.id AND users.is_active = true').uniq

  def actual_controlor
    users.where(:is_active => true).last
  end

end
