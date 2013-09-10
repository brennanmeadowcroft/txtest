class AddTimeSentToAnswers < ActiveRecord::Migration
  def up
  	add_column :answers, :time_sent, :datetime
  end
  def down
  	remove_column :answers, :time_sent
  end
end
