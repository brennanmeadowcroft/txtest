class AddPlanIdToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :plan_id, :integer
  end
  def down
  	remove_column :users, :plan_id
  end
end
