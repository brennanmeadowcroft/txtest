class AddPausedFlagToQuestions < ActiveRecord::Migration
  def up
  	add_column :questions, :paused_flag, :integer
  end
  def down
  	remove_column :questions, :paused_flag
  end
end
