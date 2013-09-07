class Course < ActiveRecord::Base
  attr_accessible :description, :user_id

  has_many :questions
end
