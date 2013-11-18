class AddTimeToEvents < ActiveRecord::Migration
  def up
  	add_column :events, :stripe_time, :date
  end
  def down
  	remove_column :events, :stripe_time
  end
end
