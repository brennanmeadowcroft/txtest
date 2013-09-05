class CreateAnswers < ActiveRecord::Migration
  def up
    create_table :answers do |t|
      t.text :submitted_answer
      t.datetime :time_answered
      t.integer :question_id
      t.integer :correct
      t.integer :in_time
      t.timestamps
    end
  end

  def down
  	drop_table :answers
  end
end
