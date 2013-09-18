class RemovePausedFlagFromSettings < ActiveRecord::Migration
  def up
  	remove_column :settings, :paused_flag
  end

  def down
  	add_column :settings, :paused_flag, :integer
  end
end
