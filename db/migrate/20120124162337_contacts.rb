class Contacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :phone
      t.string :favorite
      t.text :description
      t.integer :branch_id
      t.timestamps
    end
    add_index :contacts, :branch_id
  end

  def self.down
    drop_table :contacts
  end
end
