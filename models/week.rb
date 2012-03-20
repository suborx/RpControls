# -*- encoding : utf-8 -*-

class Week < ActiveRecord::Base
  establish_connection 'local_db'
  has_many :controls
  belongs_to :branch
  validates_presence_of :week, :message => "povinná položka"
end
