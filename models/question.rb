# -*- encoding : utf-8 -*-

class Question < ActiveRecord::Base
  establish_connection 'local_db'
  has_many :answers
  belongs_to :week
  validates_presence_of :question, :message => "povinná položka"
end
