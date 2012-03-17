class AddJobsColumnsToControls < ActiveRecord::Migration
  def self.up
    change_column :controls, :time, :integer
    add_column :controls, :was_controlled, :boolean, :default => false
    add_column :controls, :for_week, :datetime
    add_column :controls, :for_client, :string, :limit => 100
    add_column :controls, :branch_id, :integer
    add_column :controls, :control_date, :datetime
    add_column :controls, :week_number, :integer
    add_index :controls, :branch_id
    add_index :controls, :for_client
    add_index :controls, :for_week
    add_index :controls, [:for_week, :was_controlled]
  end

  def self.down
    change_column :controls, :time, :time
    remove_index :controls, :column => [:for_week, :was_controlled]
    remove_index :controls, :column => :for_week
    remove_index :controls, :column => :for_client
    remove_index :controls, :column => :branch_id
    remove_column :controls, :branch_id
    remove_column :controls, :for_client
    remove_column :controls, :control_date
    remove_column :controls, :for_week
    remove_column :controls, :was_controlled
  end
end
