class User::RestaurantsController < ApplicationController
  def new
    @restaurant = Restaurant.new
  end 

  def create
    debugger
    debugger
    user_params
  end

  private
  def restaurant_params
    params.require(:restaurant).require(:model).permit(%i[category fssai_licence])
  end
end
