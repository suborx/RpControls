# -*- encoding : utf-8 -*-

class Question < ActiveRecord::Base

  include FormErrorHelper

  attr_accessor :branch_id, :questions
  establish_connection 'local_db'

  has_many :answers
  belongs_to :week

  delegate :branch_mark, :to => :week

  validates_presence_of :question, :week_id, :message => "povinná položka"

  def self.create_questions(params)
    week = Week.find_or_create_week(params)
    questions = params[:questions].delete_if{ |q| q.blank? }
    questions.each do |q|
      week.questions.create(:question => q)
    end
    !week.questions.empty?
  end

  def update_question(params)
    week = Week.find_or_create_week(params)
    update_attributes(:question => params[:question], :week_id => week.id)
  end


end
