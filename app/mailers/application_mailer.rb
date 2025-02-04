class ApplicationMailer < ActionMailer::Base
  default from: ENV["SMTP_DOMAIN"]
  layout "mailer"
end
