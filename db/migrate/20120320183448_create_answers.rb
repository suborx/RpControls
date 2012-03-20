class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.string :answer, :null => false
      t.references :question
      t.references :controls
    end
  end

  def self.down
    drop_table :answers
  end
end
