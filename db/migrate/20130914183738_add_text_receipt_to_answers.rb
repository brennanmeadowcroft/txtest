class AddTextReceiptToAnswers < ActiveRecord::Migration
  def up
  	add_column :answers, :text_receipt, :integer
  	add_column :answers, :receipt_date, :datetime
  end
  def down
  	remove_column :answers, :text_receipt
  	remove_column :answers, :receipt_date
  end
end
