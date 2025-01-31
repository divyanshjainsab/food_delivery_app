class ApplicationController < ActionController::Base
  private
  SECRET_KEY = "MerkoNhiSMjAAI"

  public
  def encode_token(payload)
      JWT.encode(payload, SECRET_KEY)
  end

  def decoded_token(token)
    begin
        JWT.decode(token, SECRET_KEY)
    rescue JWT::DecodeError
        nil
    end
  end

  protected
  def user_params(model)
    params.require(model).require(:user).permit(%i[name password password_confirmation email phone address])
  end



  def send_otp(user)
    # genrating otp to send via mail
    otp = rand(100000 .. 999999)
    # we send mail immediatly after object creation
    UserMailer.with(user: user, otp: otp).account_creation_verification_mail.deliver_now
    # update otp in user misc
    user.misc.update! otp: otp

    # creating cookies for verify
    cookies[:temp_id] = user.id

    # redirect to verify page
    redirect_to "/verify"
    # after handling user redirect to otp verification
  end

  def user_verification(user)
    # converting email to downcase in order to avoid bugs
    user.email = user.email.downcase

    # check for user existance
    if User.find_by(email: user.email)
      if user.verified_tag
        flash[:notice] = "Account Already Exists"
        redirect_to new_auth_path
      else
        # update the existing record in db
        User.find_by(email: user.email).destroy
        user.save!
        # as_json is used in order to convert obj to hash
      end
    # as that wasn't existing, handle that as fresh
    else
      user.entryable.save
      user.save!
    end
    cookies[:temp_id] = user.id
    # returning user
    user
  end

  protected
  def get_role
    decoded_token(cookies[:role])[0] if cookies[:role]
  end

  def get_id
    decoded_token(cookies[:id])[0] if cookies[:id]
  end
end
