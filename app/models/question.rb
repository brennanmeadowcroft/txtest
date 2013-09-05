class Question < ActiveRecord::Base
  attr_accessible :answer, :question, :class_id

  has_many :answers
end
