# -*- encoding : utf-8 -*-

class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :control
  validates_presence_of :question_id, :control_id, :message => "povinná položka"
end
