class Cities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name, :null => false
    end
  end

  def self.down
    drop_table :cities
  end
end
