# -*- encoding : utf-8 -*-

class InspirationAddress < ActiveRecord::Base
  belongs_to :inspiration
  validates_presence_of :address, :control_type

  default_scope(where(:is_assigned => nil))
end
