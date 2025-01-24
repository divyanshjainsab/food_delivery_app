class ApplicationController < ActionController::Base

  private
  SECRET_KEY = "MerkoNhiSMjAAI"

  public
  def encode_token(payload)
      JWT.encode(payload, SECRET_KEY) 
  end

  def decoded_token
      header = request.headers['Authorization']
      if header
          token = header.split(" ")[1]
          begin
              JWT.decode(token, SECRET_KEY)
          rescue JWT::DecodeError
              nil
          end
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
    UserMailer.with(user: user,otp: otp).account_creation_verification_mail.deliver_now
    # update otp in user misc
    user.misc.update! otp: otp

    # creating session for verify
    session[:temp_id] = user.id

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
        redirect_to new_auth_path
      else 
        # update the existing record in db
        User.find_by(email: user.email).update user.as_json
        # as_json is used in order to convert obj to hash
      end
    # as that wasn't existing, handle that as fresh 
    else 
      user.save! 
    end

    # returning user
    user
  end

end
