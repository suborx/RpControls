class ChangeForWeekToIntegerInControls < ActiveRecord::Migration
  def self.up
    change_column :controls, :for_week, :integer
  end

  def self.down
    change_column :controls, :for_week, :datetime
  end
end
