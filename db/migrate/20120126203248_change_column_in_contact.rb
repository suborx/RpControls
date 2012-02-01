class ChangeColumnInContact < ActiveRecord::Migration
  def self.up
    remove_column :contacts, :favorite
    add_column :contacts, :is_favorite, :boolean, :default => false
  end

  def self.down
    remove_column :contacts, :is_favorite
    add_column :contacts, :favorite, :string
  end
end
