class Addresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street, :null => false
      t.string :number, :null => false
      t.integer :city_id, :null => false
    end
    add_index :addresses, :city_id
  end

  def self.down
    remove_index :addresses, :city_id
    drop_table :addresses
  end
end
