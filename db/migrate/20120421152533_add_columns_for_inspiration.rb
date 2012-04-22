class AddColumnsForInspiration < ActiveRecord::Migration
  def self.up
    add_column :inspiration_addresses, :control_type, :string
    add_column :inspiration_clients, :email, :string
    add_column :contacts, :email, :string
  end

  def self.down
    remove_column :inspiration_addresses, :control_type
    remove_column :inspiration_clients, :email
    remove_column :contacts
  end
end
