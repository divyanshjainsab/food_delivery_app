class Users::RidersController < ApplicationController
  def new
    @rider = Rider.new
  end

  def create
    # creating an object of user, with rider_params
    user = User.new user_params(:rider).merge(entryable: (Rider.new rider_params), misc: Misc.new)

    # appC
    user = user_verification(user)
    # mail send to user

    # appC
    send_otp user

    # after handling user redirect to otp verification
  end

  def index
    @orders = Order.Prepared
  end

  private
   def rider_params
    params.require(:rider).require(:model).permit(%i[driving_licence vehical_number date_of_birth])
   end
end
