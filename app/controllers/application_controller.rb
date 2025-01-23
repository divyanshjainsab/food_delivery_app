class ApplicationController < ActionController::API

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

  def otp_verify
    p 'logged'
  end
end
