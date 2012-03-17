class AddGroupIdToControls < ActiveRecord::Migration
  def self.up
    add_column :controls, :group_id, :integer
  end

  def self.down
    remove_column :controls, :group_id
  end
end
