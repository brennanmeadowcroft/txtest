class AddPasswordResetToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :reset_token, :string
  	add_column :users, :reset_sent_at, :datetime
  end
  def down
  	remove_column :users, :reset_token
  	remove_column :users, :reset_sent_at
  end
end
