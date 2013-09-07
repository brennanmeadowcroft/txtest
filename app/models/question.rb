class Question < ActiveRecord::Base
  attr_accessible :correct_answer, :question, :course_id

  has_many :answers
  belongs_to :course
end
