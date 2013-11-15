class AddActiveAccountFlagToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :active, :integer
  end
  def down
  	add_column :users, :active
  end
end
