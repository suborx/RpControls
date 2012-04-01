# -*- encoding : utf-8 -*-

class Week < ActiveRecord::Base

  establish_connection 'local_db'

  has_many :controls
  has_many :questions
  belongs_to :branch

  delegate :mark, :to => :branch, :prefix => true

  validates_presence_of :week_date, :message => "povinná položka"

  def self.find_or_create_week(params)
    branch = Branch.find(params[:branch_id])
    week = branch.weeks.find_or_create_by_week_date(:week_date => params[:week])
    week
  end

end
