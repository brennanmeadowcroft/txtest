class CreateQuestions < ActiveRecord::Migration
  def up
    create_table :questions do |t|
      t.integer :class_id
      t.text :question
      t.text :answer
      t.timestamps
    end
  end

  def down
  	drop_table :questions
  end
end
