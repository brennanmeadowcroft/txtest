class Answer < ActiveRecord::Base
  attr_accessible :submitted_answer, :time_answered, :time_sent, :correct, :in_time, :question_id, :text_receipt, :receipt_date

  belongs_to :question
  has_one :course, :through => :question
  has_one :user, :through => :course

  before_create :init


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

  def init
    self.text_receipt = 0
  end

  def update_text_receipt
    self.text_receipt = 1
    self.receipt_date = Time.now
    self.save!
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
    @client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
     
    message = @client.account.sms.messages.create(:body => self.question.question,
        :to => "+17202487155",
        :from => TWILIO_CONFIG['from'],
        :status_callback => "https://testtexts.fwd.wf/answers/#{self.id}/text_receipt")
    puts message.from
  end
end
