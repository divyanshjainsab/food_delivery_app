class Users::RestaurantsController < ApplicationController
  def new
    @restaurant = Restaurant.new
  end 

  def create
    # creating an object of user, with rider_params
    user = User.new user_params(:restaurant).merge( entryable: (Restaurant.new restaurant_params), misc: Misc.new)

    # appC
    user = user_verification(user)
    # mail send to user

    # appC
    send_otp user
    
    # after handling user redirect to otp verification
  end


  private
  def restaurant_params
    params.require(:restaurant).require(:model).permit(%i[category fssai_licence])
  end
  
end
