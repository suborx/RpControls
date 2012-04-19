class CreateInspirationAddresses < ActiveRecord::Migration
  def self.up
    create_table :inspiration_addresses do |t|
      t.string :address
      t.references :inspiration
    end
  end

  def self.down
    drop_table :inspiration_addresses
  end
end
