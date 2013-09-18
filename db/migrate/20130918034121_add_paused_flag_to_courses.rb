class AddPausedFlagToCourses < ActiveRecord::Migration
  def up
  	add_column :courses, :paused_flag, :integer
  end
  def down
  	remove_column :courses, :paused_flag
  end
end
