class CreateExams < ActiveRecord::Migration
  def up
    create_table :exams do |t|
      t.integer :course_id
      t.integer :user_id
      t.integer :completed
      t.integer :total_questions
      t.integer :questions_correct
      t.integer :time_limit
      t.integer :time_taken
      t.datetime :test_started
      t.datetime :test_ended
      t.timestamps
    end
  end

  def down
  	drop_table :exams
  end
end
