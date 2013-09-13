class Answer < ActiveRecord::Base
  attr_accessible :submitted_answer, :time_answered, :time_sent, :correct, :in_time, :question_id

  belongs_to :question
  has_one :course, :through => :question

  def self.next_unanswered_question
    self.where(:time_sent => nil, :time_answered => nil).order(:created_at)
  end

  def self.to_send(time)
    if time.is_a? Time
      formatted_time = time.strftime('%Y-%m-%d %H:%M')
    else
      formatted_time = time
    end
    self.where(:time_sent => formatted_time)
  end

  def answer_question(answer)
  	self.submitted_answer = answer

  	self.submitted_answer == self.question.correct_answer ? self.correct = 1 : self.correct = 0
  	if Time.now <= (self.created_at + 10.minutes)
  		self.in_time = 1
  	else 
  		self.in_time = 0
  	end

  	return self
  end

  def send_text

  end
end
