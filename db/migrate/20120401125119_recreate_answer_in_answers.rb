class RecreateAnswerInAnswers < ActiveRecord::Migration

  def self.up
    remove_column :answers, :answer
    add_column :answers, :answer
  end

  def self.down
    remove_column :answers, :answer
    add_column :answers, :answer
  end
end
