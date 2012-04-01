# -*- encoding : utf-8 -*-

class Answer < ActiveRecord::Base
  establish_connection 'local_db'
  belongs_to :question
  belongs_to :control
  validates_presence_of :question_id, :control_id, :message => "povinná položka"
end
