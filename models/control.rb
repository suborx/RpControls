# -*- encoding : utf-8 -*-

class Control < ActiveRecord::Base

  include FormErrorHelper

  establish_connection 'local_db'

  belongs_to :user
  belongs_to :contact

  validates_presence_of :contact_id, :if => 'was_controlled', :message => "povinná položka"
  validates_presence_of :control_date, :if => 'was_controlled', :message => "povinná položka"
  validates_presence_of :user_id, :for_week, :for_address, :control_type, :message => "povinná položka"

  default_scope(order('created_at DESC'))

  scope :with_contact_last_name, lambda { |contact_last_name| joins(:contact).where(["contacts.last_name LIKE ?", "#{contact_last_name}%"]) }
  scope :controlled, where(:was_controlled => true)
  scope :uncontrolled, where(:was_controlled => false)

  #fake have to be deleted
  def for_week
    Date.today
  end

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
    (RpControl::DEFAULT_NUMBER_OF_CONTROLS - 1).times do
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

end

