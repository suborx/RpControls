class AddIsAssignedToInspirationAddress < ActiveRecord::Migration
  def self.up
    add_column :inspiration_addresses, :is_assigned, :boolean
  end

  def self.down
    remove_column :inspiration_addresses, :is_assigned
  end
end
