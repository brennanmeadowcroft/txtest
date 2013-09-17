class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :phone_number, :password, :password_confirmation, :remember_token, :user_key
  has_secure_password

  has_many :courses
  has_many :questions, :through => :courses
  has_many :answers, :through => :courses
  has_many :settings, :through => :courses

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :first_name, :presence => true
  validates :password, :presence => true, length: { minimum: 6 }

  before_save { self.email = email.downcase }
  before_create :create_remember_token
  before_create :text_verification_code
  before_save :phone_cleanup

  def User.new_remember_token
  	SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
  	Digest::SHA1.hexdigest(token.to_s)
  end

  def send_phone_validation
    # Process the text and send it via Twilio
    @client = Twilio::REST::Client.new(ENV['twilio_sid'], ENV['twilio_token'])

    text_body = "Validating your number. Please enter this code into the form: #{ self.text_code }"
     
    message = @client.account.sms.messages.create(:body => text_body,
        :to => self.phone_number,
        :from => ENV['twilio_from'],
        :status_callback => "https://testtexts.fwd.wf/sms/#{self.id}/text_validate")
    puts message.from
  end

  private
  	def create_remember_token
  		self.remember_token = User.encrypt(User.new_remember_token)
  	end

    def phone_cleanup
      stripped_number = self.phone_number.gsub(/[-.\s()+]/, '')
      if stripped_number.length == 11
        new_number = stripped_number[1..11]
      else
        new_number = stripped_number
      end

      self.phone_number = '+1' + new_number
    end

    def text_verification_code
      self.text_code = generate_verification_code
    end

    def generate_verification_code
      size = 4
      charset = %w{ 2 3 4 6 7 9 a c d e f g h j k m n p q r t v w x y z A C D E F G H J K M N P Q R T V W X Y Z}
      key = (0..size).map{ charset.to_a[rand(charset.size) ] }.join
    
      return key
    end
end
