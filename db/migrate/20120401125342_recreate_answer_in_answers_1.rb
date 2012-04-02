class RecreateAnswerInAnswers1 < ActiveRecord::Migration
  def self.up
    remove_column :answers, :answer
  end

  def self.down
    add_column :answers, :answer, :boolean
  end
end
