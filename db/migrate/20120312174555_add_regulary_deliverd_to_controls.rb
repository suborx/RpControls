class AddRegularyDeliverdToControls < ActiveRecord::Migration
  def self.up
    rename_column :controls, :delivered, :regulary_delivered
  end

  def self.down
    rename_column :controls, :regulary_delivered, :delivered
  end
end
