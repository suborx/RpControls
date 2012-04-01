# -*- encoding : utf-8 -*-

class Week < ActiveRecord::Base

  establish_connection 'local_db'

  has_many :controls
  has_many :questions
  belongs_to :branch

  delegate :mark, :to => :branch, :prefix => true

  validates_presence_of :week_date, :message => "povinná položka"
end
