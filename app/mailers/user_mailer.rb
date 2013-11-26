class UserMailer < ActionMailer::Base
  default from: "support@txtest.com"

  def welcome_email(user)
  end

  def password_reset(user)
  	@user = user
  	mail :to => user.email, :subject => "Reset Your Txtest.com Password"
  end
end
