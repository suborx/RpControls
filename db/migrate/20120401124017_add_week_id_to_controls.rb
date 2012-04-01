class AddWeekIdToControls < ActiveRecord::Migration
  def self.up
    add_column :controls, :week_id, :integer
    add_index :controls, :week_id
  end

  def self.down
    remove_index :controls, :week_id
    remove_column :controls, :week_id
  end
end
