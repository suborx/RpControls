class RecreateAnswerInAnswers2 < ActiveRecord::Migration
  def self.up
    add_column :answers, :answer, :string
  end

  def self.down
    remove_column :answers, :answer
  end
end
