class CreateInpirationTable < ActiveRecord::Migration
  def self.up
    create_table :inspirations do |t|
      t.text :description
      t.references :week
      t.references :contact
      t.references :client
    end
  end

  def self.down
    drop_table :inspirations
  end
end
