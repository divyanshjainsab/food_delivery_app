class Users::ClientsController < ApplicationController
  def new
    @client = Client.new
  end 

  def show
  end

  def create
    # creating an object of user, as client has no additional fileds we will use only Client.new
    @user = User.new user_params(:client), entryable: Client.new

    # genrating otp to send via mail
    @otp = rand(100000 .. 999999)
    # we send mail immediatly after object creation
    UserMailer.with(user: @user,otp: @otp).account_creation_verification_mail.deliver_now


    # TODO
    # expecting a prompt to be added here so that we take otp from user recieved via mail
    # if they matched, we will create the user (otp verification mandatory)

    # js logic
    # otp = prompt("Enter the otp recieved via mail.")
    # if otp == @otp
    #   if @user.save! 
    #     alert("User saved successfully")
    #   else
    #     alert("There might be some validation issues")
    #   end
    # else
    #   alert("unable to verify user")
    # end

    # got hint about bootstrap modal
  end


  
end
