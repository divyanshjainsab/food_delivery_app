class UserController < ApplicationController
  def index
    case get_role
    when "Client"
      redirect_to restaurants_path
    when "Restaurant"
      redirect_to restaurant_dishes_path
    when "Rider"
      redirect_to rider_dashboard_path
    end
  end

  def signup
    redirect_to root_path if cookies[:id]
  end

  def email_verification
    redirect_to root_path unless session[:temp_id]
  end

  def verification
    user = User.unscoped.find(session[:temp_id])
    if user.misc.otp == params[:otp].to_i
      user.update_column(:verified_tag, true)
      session.delete :temp_id
      flash[:notice] = "#{user.entryable_type} successfully created."
      UserMailer.account_creation_confirmation_mail(user).deliver_now
      redirect_to root_path
    else
      flash[:notice] = "Invalid OTP"
      redirect_to verify_path
    end
  end

  def resend_otp
    flash[:notice] = "OTP has been resent to your email."
    send_otp User.unscoped.find session[:temp_id]
  end
end
