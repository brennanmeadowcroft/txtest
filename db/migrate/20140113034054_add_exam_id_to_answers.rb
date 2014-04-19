class AddExamIdToAnswers < ActiveRecord::Migration
  def up
  	add_column :answers, :exam_id, :integer
  end
  def down
  	remove_column :answers, :exam_id
  end
end
