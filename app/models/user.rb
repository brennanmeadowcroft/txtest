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

  def User.new_remember_token
  	SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
  	Digest::SHA1.hexdigest(token.to_s)
  end

  private
  	def create_remember_token
  		self.remember_token = User.encrypt(User.new_remember_token)
  	end
end
