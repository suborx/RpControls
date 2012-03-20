class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string :question, :null => false
      t.references :week
    end
  end

  def self.down
    drop_table :questions
  end
end
