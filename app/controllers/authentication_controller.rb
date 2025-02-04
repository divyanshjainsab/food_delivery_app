class AuthenticationController < ApplicationController
  def create
    # check for user existance with given email but in lowercase, as records are in same way
    user = User.find_by(email: params[:email].downcase)

    # if user found then proceed for next action
    if user&.authenticate(params[:password])
      role = user.entryable_type
      entryable_id = user.entryable_id
      cookies[:id] = encode_token(entryable_id)
      cookies[:role] = encode_token(role)

      prev_path = session[:return_to] 
      session.delete(:return_to)
      redirect_to prev_path

    else
      flash[:notice] = "Invalid Email or Password"
      redirect_to new_auth_path
    end
  end

  def new
    if cookies[:id]
      redirect_to root_path
    else
      store_location
    end
  end

  def logout
    cookies.delete :id
    cookies.delete :role
    redirect_back(fallback_location:"/")
  end

  private
  def store_location
    if request.post? || request.put?
      session[:return_to] = request.env['HTTP_REFERER']
    else
      session[:return_to] = request.referer
    end
  end
  
end
