# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Bloccit::Application.initialize!

# Configuration for using SendGrid on Heroku
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address              => 'smtp.sendgrid.net',
  :port                 => '587',
  :authentication       => :plain,
  :user_name            => ENV["app27522993@heroku.com"],
  :password             => ENV["piqzscx8"],
  :domain               => 'heroku.com',
  :enable_starttls_auto => true
}