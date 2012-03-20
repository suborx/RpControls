class RepairBadWeeksMigration < ActiveRecord::Migration
  def self.up
    change_column :weeks, :week_date, :date
    remove_column :weeks, :date
  end

  def self.down
    change_column :weeks, :week_date, :string
    add_column :weeks, :date
  end
end
