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
    # Find all answers that have a time sent matching the submitted time
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
    # Update the record when notified that a text was sent successfully
    self.text_receipt = 1
    self.receipt_date = Time.now
    self.save!
  end

  def submit_response(response_body)
    # Process the body of the text and update the answer with the submitted response
    response = response_body.gsub(/\s?Q\d+\s?/, "")

    self.submitted_answer = response
    Time.now <= (self.receipt_date + 10.minutes) ? self.in_time = 1 : self.in_time = 0
    if self.submitted_answer.upcase == self.question.correct_answer.upcase
      self.correct = 1
    end

    self.save!
  end

  def send_text
    # Process the text and send it via Twilio
    @client = Twilio::REST::Client.new(ENV['twilio_sid'], ENV['twilio_token'])

    text_body = "#{self.question.question} || Respond within 10 minutes and include the code Q#{self.id} to get credit. Good luck!"
     
    message = @client.account.sms.messages.create(:body => text_body,
        :to => self.user.phone_number,
        :from => ENV['twilio_from'],
        :status_callback => "https://testtexts.fwd.wf/answers/#{self.id}/text_receipt")
    puts message.from
  end
end
