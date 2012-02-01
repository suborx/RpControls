class RenameColumnsInControls < ActiveRecord::Migration
  def self.up
    rename_column :controls, :type, :control_type
  end

  def self.down
    rename_column :controls, :control_type, :type
  end
end
