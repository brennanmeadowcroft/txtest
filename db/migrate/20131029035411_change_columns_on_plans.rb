class ChangeColumnsOnPlans < ActiveRecord::Migration
  def up
  	rename_column :plans, :monthly_fee, :fee
  	change_column :plans, :interval, :string
  end

  def down
  	rename_column :plans, :fee, :monthly_fee
  	change_column :plans, :string, :interval
  end
end
