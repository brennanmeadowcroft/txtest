class User < ActiveRecord::Base
  attr_accessible :admin, :active, :email, :first_name, :last_name, :phone_number, :password, :password_confirmation, 
                  :remember_token, :user_key, :stripe_token, :stripe_id, :last_4_digits, :expiration_date, :plan_id, :card_problem_flag
  has_secure_password

  has_one :settings
  belongs_to :plan
  has_many :courses
  has_many :questions, :through => :courses
  has_many :answers, :through => :courses
  has_many :events

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :first_name, :presence => true
  validates :password, :presence => true, length: { minimum: 6 }, :on => :create
  validates :password_confirmation, :presence => true, :on => :create

  before_save { self.email = email.downcase }
  before_save { self.admin ||= 0 }
  before_create { self.active = 1 }
  before_save { self.card_problem_flag ||= 0}
  before_create :create_remember_token
  before_create :text_verification_code
  before_save :phone_cleanup
  before_save :update_stripe
  before_save :deactivate_account
  before_save :enforce_plan_limits
  before_destroy :close_stripe

  def User.new_remember_token
  	SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
  	Digest::SHA1.hexdigest(token.to_s)
  end

  def self.with_unpaused_courses
    # Find all active users with at least one unpaused course to create a schedule for the day
    #self.find_by_sql("SELECT * FROM users INNER JOIN courses ON(users.id = courses.user_id) WHERE courses.paused_flag = 0")
    self.joins(:courses).where(courses: {paused_flag: 0}, users: {active: 1})
  end

  def problem_with_card
    # Set the problem flag to 1 so the user can be notified
    self.card_problem_flag = 1

    # Set the user account to inactive to avoid extraneous charges
    plan = Plan.where(:name => "Inactive Account").first
    self.plan_id = plan.id
    self.active = 1

    self.save
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

  def toggle_admin
    # Set the users account to admin and edit the account type
    if self.admin == 1 
      self.admin = 0
      plan = Plan.where(:name => "Inactive Account")
      self.plan_id = plan.first.id
      self.active = 0
    else
      self.admin = 1
      self.active = 1
      plan = Plan.where(:name => "Admin")
      self.plan_id = plan.first.id
    end

    self.save!
  end

  def enforce_plan_limits
    # Get the user plan information
    plan = self.plan

    # Check plan limits
    self.settings.enforce_plan_limits
    self.courses.enforce_plan_limits(plan.max_courses)
    self.questions.enforce_plan_limits(plan.max_questions)
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

    def deactivate_account
      plan = Plan.where(:name => "Inactive Account")
      # Check whether the user account is inactive... if so, change subscription
      if self.admin == 0 
        if self.active == 0 
          self.plan_id = plan.first.id
        end
      else 
        self.active = 1
      end

      # Check whether account is anything other than "Inactive"... if so, make sure active account is checked
      if self.plan_id != plan.first.id and self.card_problem_flag != 1
        self.active = 1
      end

      update_stripe
    end

    def generate_verification_code
      size = 4
      charset = %w{ 2 3 4 6 7 9 a c d e f g h j k m n p q r t v w x y z A C D E F G H J K M N P Q R T V W X Y Z}
      key = (0..size).map{ charset.to_a[rand(charset.size) ] }.join
    
      return key
    end

    def stripe_description
      "#{ first_name } #{ last_name }: #{ email }"
    end

    def update_stripe
      if stripe_token.present?
        if stripe_id.nil?
          customer = Stripe::Customer.create(
              :email => email,
              :description => stripe_description,
              :card => stripe_token
            )
          customer.save
          
          self.last_4_digits = customer.cards.retrieve(customer.default_card).last4
          customer.update_subscription({:plan => self.plan_id })
        else 
          customer = Stripe::Customer.retrieve(stripe_id)
          customer.card = stripe_token
          # Update just in case it has been changed
          customer.email = self.email
          customer.description = stripe_description
          customer.update_subscription({:plan => self.plan_id})

          customer.save

          self.last_4_digits = customer.cards.retrieve(customer.default_card).last4
          self.card_problem_flag = 0
        end
      else
          customer = Stripe::Customer.retrieve(stripe_id)
          # Update just in case it has been changed
          customer.email = self.email
          customer.description = stripe_description
          customer.update_subscription({:plan => self.plan_id})

          customer.save
      end

      self.stripe_id = customer.id
      self.stripe_token = nil
    end

    def close_stripe
      customer = Stripe::Customer.retrieve(stripe_id)
      customer.delete
    end
end
