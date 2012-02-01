class AddMarkColumnToBranches < ActiveRecord::Migration
  def self.up
    add_column :branches, :mark, :string
  end

  def self.down
    remove_column :branches, :mark
  end
end
