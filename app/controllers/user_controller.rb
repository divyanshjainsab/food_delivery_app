class UserController < ApplicationController
  def index
  end

  def signup
  end

  def email_verification
  end

  def verification
    user = User.find(session[:temp_id])
    if user.misc.otp == params[:otp].to_i
      user.update_column(:verified_tag, true)
      session[:temp_id] = nil
      UserMailer.with(user: user).account_creation_verification_mail.deliver_now
      redirect_to '/'
    end
  end
end
