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
    UserMailer.account_creation_verification_mail(user, otp).deliver_now
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
    user.verified_tag = false
    # check for user existance
    db_user = User.find_by_email user.email
    # if user in db found
    if db_user
      flash[:notice] = "Account Already Exists"
      redirect_to new_auth_path
      return
    else
      # now either user really not exist or unverified
      db_user = User.unscoped.find_by_email user.email

      if db_user
        # now the user is present in db but still not verified to we can save both records by skipping validations
        user.email = "testemailinordertoskipduplicateemailerror@timpass.org"

        save_user user
        user.update_attribute :email, db_user.email
        # now there are more than one user with same email, but they all are unverified
      else
        # as that wasn't existing, handle that as fresh
        save_user user
      end
      # creating a session to verify user
      session[:temp_id] = user.id
      # returning user
      return user
    end

  end

  def get_role
    decoded_token(cookies[:role])[0] if cookies[:role]
  end

  def get_id
    decoded_token(cookies[:id])[0] if cookies[:id]
  end

  private
  def save_user(user)
    if user.valid?
      if user.entryable.save! 
        user.save!
      end
    end
  end
end
