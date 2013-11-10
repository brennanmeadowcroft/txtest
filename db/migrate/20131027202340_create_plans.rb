class CreatePlans < ActiveRecord::Migration
  def up
    create_table :plans do |t|
      t.string :name
      t.integer :monthly_fee
      t.integer :interval
      t.integer :trial_period_days
      t.integer :max_texts
      t.integer :max_courses
      t.integer :max_questions
      t.timestamps
    end
  end
  def down
  	drop_table :plans
  end
end
