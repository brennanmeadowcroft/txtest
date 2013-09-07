class RenameClassIdToCourseIdOnQuestions < ActiveRecord::Migration
  def up
  	rename_column :questions, :class_id, :course_id
  end

  def down
  	rename_column :questions, :course_id, :class_id
  end
end
