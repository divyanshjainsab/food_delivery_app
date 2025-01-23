class AuthenticationController < ApplicationController
  def index
    session[:id], session[:role] = nil, nil
    render html: 'logout'
  end
  
  def create
    # check for user existance with given email
    user = User.find_by(email: params[:email])

    # if user found then proceed for next action
    if user 
      if user.authenticate(params[:password])
        session[:id] = encode_token(user.id)
        session[:role] = encode_token(user.entryable_type)
        render html: "#{session[:id]} #{session[:role]}"
      end
    else
      render html: "invalid id pass"
    end
  end


end
