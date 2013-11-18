class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.integer :user_id
      t.string :stripe_event_id
      t.string :stripe_customer_id
      t.string :type
      t.string :sub_type
      t.string :action
      t.timestamps
    end
  end
  def down
  	drop_table :events
  end
end
