class AuthenticationController < ApplicationController
  def create
    # check for user existance with given email but in lowercase, as records are in same way
    user = User.find_by(email: params[:email].downcase)

    # if user found then proceed for next action
    if user&.authenticate(params[:password])
      role = user.entryable_type
      entryable_id = user.entryable.id
      cookies[:id] = encode_token(entryable_id)
      cookies[:role] = encode_token(role)
      case role
      when "Client"
          redirect_to root_path
      when "Restaurant"
        redirect_to "/restaurant/dishes"
      end
    else
      flash[:notice] = "Invalid Email or Password"
      redirect_to new_auth_path
    end
  end

  def new
    redirect_to "/" if cookies[:id]
  end

  def logout
    cookies.delete :id
    cookies.delete :role
    redirect_to "/"
  end
end
