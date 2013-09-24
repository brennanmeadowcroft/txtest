class Answer < ActiveRecord::Base
  attr_accessible :submitted_answer, :time_answered, :time_sent, :correct, :in_time, :question_id, :text_receipt, :receipt_date

  belongs_to :question
  has_one :course, :through => :question
  has_one :user, :through => :course

  before_create :init


  def self.next_unanswered_question
    self.where(:time_sent => nil, :time_answered => nil).order(:created_at)
  end

  def self.to_send
    # Get the current time from the server.  Time is stored in MySQL as UTC and will be converted by the
    # DB for the sake of the query.  We want the current time to know when to send it.  The time needs to be 
    # broken down because we don't want seconds... answers stored in DB have "00" as seconds.
    current_time = Time.now #Time from the server where the application is located in, not UTC
    # Deconstruct the time into individual components for the query
    current_year = Time.now.strftime("%Y").to_i
    current_month = Time.now.strftime("%m").to_i
    current_day = Time.now.strftime("%d").to_i
    current_hour = Time.now.strftime("%H").to_i
    current_minute = current_time.strftime("%M").to_i
    # Create a timestamp of the new date/time for the query.  Will be turned into UTC by the DB.
    where(:time_sent => Time.new(current_year, current_month, current_day, current_hour, current_minute))
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
    Time.now <= (Time.parse(self.time_sent.to_s) + (self.user.settings.response_time*60)) ? self.in_time = 1 : self.in_time = 0
    if self.submitted_answer.upcase == self.question.correct_answer.upcase
      self.correct = 1
    end

    self.save!
  end

  def send_text
    # Process the text and send it via Twilio
    @client = Twilio::REST::Client.new(ENV['twilio_sid'], ENV['twilio_token'])

    text_body = "#{self.question.question} || Respond within #{self.user.settings.response_time} minutes and include the code Q#{self.id} to get credit. Good luck!"
     
    message = @client.account.sms.messages.create(:body => text_body,
        :to => self.user.phone_number,
        :from => ENV['twilio_from'],
        :status_callback =>"http://www.txtest.com/answers/#{self.id}/text_receipt")
    puts message.from
  end
end
