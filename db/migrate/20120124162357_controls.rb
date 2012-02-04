class Controls < ActiveRecord::Migration
  def self.up
    create_table :controls do |t|
      t.boolean :delivered
      t.boolean :successful_call
      t.text :notice
      t.time :time
      t.integer :contact_id
      t.integer :user_id
      t.timestamps
    end
    add_index :controls, :contact_id
    add_index :controls, :user_id
  end

  def self.down
    drop_table :contacts
  end
end
