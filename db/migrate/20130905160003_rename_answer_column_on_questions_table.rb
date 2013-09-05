class RenameAnswerColumnOnQuestionsTable < ActiveRecord::Migration
  def up
  	rename_column :questions, :answer, :correct_answer
  end

  def down
  	rename_column :questions, :correct_answer, :answer
  end
end
