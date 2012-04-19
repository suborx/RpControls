class CreateInspirationClients < ActiveRecord::Migration
  def self.up
    create_table :inspiration_clients do |t|
      t.string :name
      t.string :ico
      t.string :contact_person
      t.string :phone
      t.references :inspiration
    end
  end

  def self.down
    drop_table :inspiration_addresses
  end
end
