class RenameCourseIdOnSettings < ActiveRecord::Migration
  def up
  	rename_column :settings, :course_id, :user_id
  end

  def down
  	rename_column :settings, :user_id, :course_id
  end
end
