class Account < ActiveRecord::Base
  attr_accessible :user_id, :plan_id, :active, :stripe_token, :last_cc_digits

  belongs_to :user
  belongs_to :plan
end
