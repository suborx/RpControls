class CreateWeeks < ActiveRecord::Migration
  def self.up
    create_table :weeks do |t|
      t.string :week_date, :date, :null => false
      t.references :branch
    end
  end

  def self.down
    drop_table :weeks
  end
end
