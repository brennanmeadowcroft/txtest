class Answer < ActiveRecord::Base
  attr_accessible :submitted_answer, :time_answered, :correct, :in_time, :question_id

  belongs_to :question
end
