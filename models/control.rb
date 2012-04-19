# -*- encoding : utf-8 -*-

class Control < ActiveRecord::Base

  require_relative '../lib/extensions'
  include FormErrorHelper

  attr_accessor :questions, :answers, :for_week

  belongs_to :user
  belongs_to :contact
  belongs_to :week
  has_many :assigned_answers, :class_name => 'Answer', :dependent => :destroy
  has_many :assigned_questions, :through => :assigned_answers, :source => :question, :class_name => "Question"

  before_save :assign_week, :update_answers
  after_save :assign_questions

  validates_presence_of :contact_id, :if => 'was_controlled', :message => "povinná položka"
  validates_presence_of :control_date, :if => 'was_controlled', :message => "povinná položka"
  validates_presence_of :for_week, :unless => 'was_controlled', :message => "povinná položka"
  validates_presence_of :user_id, :for_address, :control_type

  default_scope(order('created_at DESC'))

  scope :with_contact_last_name, lambda { |contact_last_name| joins(:contact).where(["contacts.last_name LIKE ?", "#{contact_last_name}%"]) }
  scope :controlled, where(:was_controlled => true)
  scope :uncontrolled, where(:was_controlled => false)

  def self.search(user,search_query=nil)
    if user.is_admin?
      search_query ? with_contact_last_name(search_query) : self
    else
      controls =  where(:user_id => user.id)
      search_query ? controls.with_contact_last_name(search_query) : controls
    end
  end

  def self.find_related_controls(group_id)
    where(:group_id => group_id)
  end

  def current_week
    d = DateTime.parse(created_at.to_s)
    d.cweek
  end

  def create_default_number_of_controls
    return false unless save
    update_attributes(:group_id => id)
    (Sinatra::Application::DEFAULT_NUMBER_OF_CONTROLS - 1).times do
      control_dup = self.dup
      control_dup.save
    end
  end

  def update_related_controls(params)
    related_controls = Control.find_related_controls(group_id)
    related_controls.each{ |c| @valid = c.update_attributes(params)}
    update_attributes(params) unless @valid
    @valid
  end

  private

  def update_answers
    return if answers.blank?
    answers.each_pair do |k,v|
      Answer.find(k).update_attribute(:answer,v)
    end
  end

  def assign_questions
    return if questions.blank? || was_controlled
    assigned_answers.delete_all
    questions.each{ |q| Answer.find_or_create_by_control_id_and_question_id(:control_id => self.id , :question_id => q)}
  end

  def assign_week
    return if for_week.blank?
    user = User.find(user_id)
    if user && for_week
      self.week_id = Week.find_or_create_week({:branch_id => user.branch_id, :week => for_week}).id
    end
  end
end

