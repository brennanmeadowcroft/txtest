class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id
      t.integer :plan_id
      t.integer :active
      t.string :stripe_token
      t.integer :last_cc_digits
      t.timestamps
    end
  end
end
