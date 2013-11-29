class AddValidationFieldsToUser < ActiveRecord::Migration
  def up
  	add_column :users, :email_verified, :integer
  	add_column :users, :email_verification_code, :string
  	add_column :users, :phone_verified, :integer
  	add_column :users, :phone_verification_code, :string
  end
  def down
  	remove_column :users, :email_verified
  	remove_column :users, :email_verification_code
  	remove_column :users, :phone_verified
  	remove_column :users, :phone_verification_code
  end
end
