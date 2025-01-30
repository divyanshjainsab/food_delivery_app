class UserController < ApplicationController
  def index
  end

  def signup
  end

  def email_verification
    redirect_to '/' unless cookies[:temp_id]
  end

  def verification
    user = User.find(cookies[:temp_id])
    if user.misc.otp == params[:otp].to_i
      user.update_column(:verified_tag, true)
      cookies[:temp_id] = nil
      UserMailer.with(user: user).account_creation_confirmation_mail.deliver_now
      redirect_to '/'
    end
  end

  def resend_otp
    flash[:notice] = "OTP has been resent to your email."
    send_otp
  end
end
