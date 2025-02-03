class Users::ClientsController < ApplicationController
  def new
    @client = Client.new
  end

  def show
  end

  def create
    # creating an object of user, as client has no additional fileds we will use only Client.new
    user = User.new user_params(:client).merge(entryable: Client.new, misc: Misc.new)

    # appC
    user = user_verification user
    # mail send to user

    # appC
    send_otp user

    # after handling user redirect to otp verification
  end
end
