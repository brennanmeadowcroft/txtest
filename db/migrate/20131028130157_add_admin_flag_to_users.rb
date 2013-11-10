class AddAdminFlagToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :admin, :integer
  end
  def down
  	drop_column :users, :admin
  end
end
