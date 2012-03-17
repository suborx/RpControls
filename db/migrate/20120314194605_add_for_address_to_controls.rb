class AddForAddressToControls < ActiveRecord::Migration
  def self.up
    add_column :controls, :for_address, :string
  end

  def self.down
    remove_column :controls, :for_address
  end
end
