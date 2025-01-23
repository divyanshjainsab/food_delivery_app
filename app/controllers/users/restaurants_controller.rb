class Users::RestaurantsController < ApplicationController
  def new
    @restaurant = Restaurant.new
  end 

  def create
  end

  private
  def restaurant_params
    params.require(:restaurant).require(:model).permit(%i[category fssai_licence])
  end
end
