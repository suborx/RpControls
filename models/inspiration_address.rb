# -*- encoding : utf-8 -*-

class InspirationAddress < ActiveRecord::Base
  belongs_to :inspiration
  validates_presence_of :address, :control_type
end
