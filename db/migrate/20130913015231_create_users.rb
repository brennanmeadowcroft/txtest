class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.string :password_digest
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :phone_number, unique: true
  end
  def down
  	drop_table :users
  end
end
