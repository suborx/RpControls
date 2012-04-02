# -*- encoding : utf-8 -*-

class Question < ActiveRecord::Base

  include FormErrorHelper

  attr_accessor :branch_id, :questions
  establish_connection 'local_db'

  has_many :answers
  belongs_to :week

  delegate :branch_mark, :to => :week

  validates_presence_of :question, :week_id, :message => "povinná položka"

  def self.empty_relation_object
    where(:id => 0)
  end

  def self.search(params)
    if params
      query_opts = {:week_date => params[:week_date]}.merge!(params[:branch_id] ? {:branch_id => params[:branch_id]} : {})
      week = Week.first(:conditions => query_opts)
      week ? week.questions : empty_relation_object
    else
      self
    end
  end

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

  def has_answer_for_control?(control_id)
    control_id == 'undefined' ? false : !!answers.find_by_control_id(control_id)
  end

end
