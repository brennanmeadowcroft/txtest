class AddPrivateFlagToPlans < ActiveRecord::Migration
  def up
  	add_column :plans, :private_plan, :integer
  end
  def down
  	remove_column :plans, :private_plan
  end
end
