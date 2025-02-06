class UserController < ApplicationController
  def index
    case get_role
    when "Client"
      redirect_to restaurants_path
    when "Restaurant"
      redirect_to restaurant_dishes_path
    when "Rider"
      # lets see
    end
  end

  def signup
    redirect_to "/" if cookies[:id]
  end

  def email_verification
    redirect_to "/" unless cookies[:temp_id]
  end

  def verification
    user = User.find(cookies[:temp_id])
    if user.misc.otp == params[:otp].to_i
      user.update_column(:verified_tag, true)
      cookies[:temp_id] = nil
      UserMailer.with(user: user).account_creation_confirmation_mail.deliver_now
      redirect_to "/"
    else
      flash[:notice] = "Invalid OTP"
      redirect_to verify_path
    end
  end

  def resend_otp
    flash[:notice] = "OTP has been resent to your email."
    send_otp User.find(cookies[:temp_id])
  end
end
