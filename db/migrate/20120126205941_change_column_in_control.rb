class ChangeColumnInControl < ActiveRecord::Migration
  def self.up
    add_column :controls, :verified, :boolean
    add_column :controls, :import_id, :boolean
  end

  def self.down
    remove_column :controls, :verified
    remove_column :controls, :import_id
  end
end
