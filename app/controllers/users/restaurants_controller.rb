class Users::RestaurantsController < ApplicationController
  def new
    @restaurant = Restaurant.new
  end

  def create
    # creating an object of user, with rider_params
    user = User.new user_params(:restaurant).merge(entryable: (Restaurant.new restaurant_params), misc: Misc.new)

    # appC
    user = user_verification(user)
    # mail send to user

    # appC
    send_otp user if user

    # after handling user redirect to otp verification
  end

  def index
    @role = get_role
    if @role == "Client"
      @client = Client.find get_id
    end
    @restaurants = Restaurant.all
  end

  def show
    @dishes = Restaurant.find(params[:id]).dishes
    @role = get_role
  end

  private
  def restaurant_params
    params.require(:restaurant).require(:model).permit(%i[category fssai_licence avatar])
  end
end
