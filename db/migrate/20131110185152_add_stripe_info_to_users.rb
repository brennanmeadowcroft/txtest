class AddStripeInfoToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :stripe_token, :string
  	add_column :users, :last_4_digits, :string
  	add_column :users, :expiration_date, :string
  end

  def down
  	remove_column :users, :stripe_token
  	remove_column :users, :last_4_digits
  	remove_column :users, :expiration_date
  end
end
