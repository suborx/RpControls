class RemoveForWeekFromControls < ActiveRecord::Migration
  def self.up
    remove_column :controls, :for_week
  end

  def self.down
    add_column :controls, :for_week, :date
  end
end
