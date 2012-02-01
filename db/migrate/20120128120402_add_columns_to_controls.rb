class AddColumnsToControls < ActiveRecord::Migration
  def self.up
    add_column :controls, :type, :string
    rename_column :controls, :successful_call, :succeed
  end

  def self.down
    remove :controls, :type
    rename_column :controls, :succeed, :successful_call
  end

end
