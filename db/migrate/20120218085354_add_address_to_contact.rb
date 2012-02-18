class AddAddressToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :address_id, :integer, :null => false
  end

  def self.down
    remove_column :contacts, :address_id
  end
end
