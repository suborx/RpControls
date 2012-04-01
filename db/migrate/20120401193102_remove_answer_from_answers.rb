class RemoveAnswerFromAnswers < ActiveRecord::Migration
  def self.up
    change_column :answers, :answer, :boolean, :default => false
  end

  def self.down
    change_column :answers, :answer, :string
  end
end
