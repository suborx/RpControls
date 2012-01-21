class CreateBranches < ActiveRecord::Migration
  def self.up
    create_table :branches do |t|
      t.string :name, :null => false
    end
  end

  def self.down
    drop_table :braches
  end
end
