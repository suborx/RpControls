class ChangeWeekInControls < ActiveRecord::Migration
  def self.up
    remove_column :controls, :week_number
    change_column :controls, :for_week, :date
  end

  def self.down
    change_column :controls, :for_week, :integer
    add_column :controls, :week_number, :integer
  end
end
