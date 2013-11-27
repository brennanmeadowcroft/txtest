ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address				=> "mail.txtest.com",
  :port                 => 25,
  :domain               => "txtest.com",
  :user_name            => ENV['mail_user_name'],
  :password             => ENV['mail_password'],
  :authentication       => "plain",
  :enable_starttls_auto => true,
  :openssl_verify_mode => 'none'
}
