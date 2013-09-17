class CreateSettings < ActiveRecord::Migration
  def up
    create_table :settings do |t|
      t.integer :course_id
      t.integer :texts_per_day
      t.integer :start_time
      t.integer :end_time
      t.integer :response_time
      t.integer :paused_flag
      t.timestamps
    end
  end

  def down
  	drop_table :settings
  end
end
