class CreateCourses < ActiveRecord::Migration
  def up
    create_table :courses do |t|
      t.string :description
      t.integer :user_id
      t.timestamps
    end
  end

  def down
  	drop_table :courses
  end
end
