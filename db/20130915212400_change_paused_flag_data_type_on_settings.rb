class ChangePausedFlagDataTypeOnSettings < ActiveRecord::Migration
  def up
  	change_column :settings, :paused_flag, :integer
  end

  def down
  	change_column :settings, :paused_flag, :binary
  end
end
