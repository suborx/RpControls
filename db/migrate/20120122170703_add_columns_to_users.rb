class AddColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :branch_id, :integer
    add_index :users, :branch_id
  end

  def self.down
    remove_index :users, :branch_id
    remove_column :users, :branch_id
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :phone
  end
end
