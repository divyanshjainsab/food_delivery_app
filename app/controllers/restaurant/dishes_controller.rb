class Restaurant::DishesController < ApplicationController
  # adding callbacks
  before_action :check_role
  
  def index
    # get_id returns user id, by which we will get restaurant_id and take dishes form there
    @restaurant = Restaurant.find(get_id)
  end
  
  def new
    @dish = Dish.new
  end
    
  def create
    @dish = Dish.new dish_params.merge(restaurant_id: get_id)
  end 

  def show
    @dish = Dish.find(params[:id])
  end

  private
  def check_role
    unless get_role == "Restaurant"
      flash[:notice] = "Kindly Login with Restaurant ID"
      redirect_to new_auth_path 
    end
  end

  def dish_params
    params.require(:dish).permit(:name, :description, :price, :category)
  end
end
