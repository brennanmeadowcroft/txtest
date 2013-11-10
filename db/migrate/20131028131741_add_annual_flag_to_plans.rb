class AddAnnualFlagToPlans < ActiveRecord::Migration
  def up
  	add_column :plans, :annual_plan, :integer
  end
  def down
  	remove_column :plans, :annual_plan
  end
end
