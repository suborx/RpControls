class RenameControlsIdInAnswers < ActiveRecord::Migration
  def self.up
    rename_column :answers, :controls_id, :control_id
  end

  def self.down
    rename_column :answers, :control_id, :controls_id
  end
end
