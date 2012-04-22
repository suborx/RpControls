# -*- encoding : utf-8 -*-

class Week < ActiveRecord::Base

  has_many :inspirations
  has_many :controls
  has_many :questions
  belongs_to :branch

  delegate :mark, :to => :branch, :prefix => true

  validates_presence_of :week_date, :message => "povinná položka"

  def self.find_or_create_week(params)
    Week.find_or_create_by_week_date_and_branch_id(:week_date => params[:week], :branch_id => params[:branch_id])
  end

  def self.current_week_date
    year = Date.today.year
    week = yield Date.today.cweek
    Date.commercial(year,week)
  end
end
