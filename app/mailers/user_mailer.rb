class UserMailer < ApplicationMailer
  default from: "food@delivery.app"

  def account_creation_verification_mail
    @otp = params[:otp]
    @user = params[:user]
    mail(to: @user.email, subject: "Account creation request @ food.Delivery.com" )
  end

  def account_creation_confirmation_mail
    @user = params[:user]
    mail(to: @user.email, subject: "Your account is successfully created with role of #{@user.entryable_type}" )
  end
end
