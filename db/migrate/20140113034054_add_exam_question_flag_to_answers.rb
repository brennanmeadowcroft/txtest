class AddExamQuestionFlagToAnswers < ActiveRecord::Migration
  def up
  	add_column :answers, :exam_question_flag, :integer
  end
  def down
  	remove_column :answers, :exam_question_flag
  end
end
