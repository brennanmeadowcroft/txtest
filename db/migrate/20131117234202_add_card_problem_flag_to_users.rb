class AddCardProblemFlagToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :card_problem_flag, :integer
  end
  def down
  	remove_column :users, :card_problem_flag
  end
end
