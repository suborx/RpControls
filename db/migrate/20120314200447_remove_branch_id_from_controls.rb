class RemoveBranchIdFromControls < ActiveRecord::Migration
  def self.up
    remove_column :controls, :branch_id
  end

  def self.down
    add_column :controls, :branch_id
  end
end
