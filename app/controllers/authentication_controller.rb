class AuthenticationController < ApplicationController
  def index
    session[:id], session[:role] = nil, nil
    redirect_to root_path
  end
  
  def create
    # check for user existance with given email but in lowercase, as records are in same way
    user = User.find_by(email: params[:email].downcase)

    # if user found then proceed for next action
    if user&.authenticate(params[:password])
      session[:id] = encode_token(user.id)
      session[:role] = encode_token(user.entryable_type)
      redirect_to root_path
    else
      render html: "invalid id pass", status: :unauthorized
    end
  end


end
