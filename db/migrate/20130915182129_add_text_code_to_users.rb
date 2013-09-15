class AddTextCodeToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :text_code, :string
  end

  def down
  	remove_column :users, :text_code
  end
end
