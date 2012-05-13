class AddAssociationToControlWithInspiration < ActiveRecord::Migration
  def self.up
    add_column :controls, :inspiration_id, :integer
    add_index :controls, :inspiration_id
    add_column :inspirations, :is_posted, :boolean, :default => false
  end

  def self.down
    remove_column :controls, :inspiration_id
    remove_index :controls, :inspiration_id
    remove_column :inspirations, :is_posted
  end
end
