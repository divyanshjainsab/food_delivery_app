class Restaurant::DishesController < ApplicationController
  # adding callbacks
  before_action :check_role
  skip_before_action :check_role, only: %i[ show ]
  layout "restaurant"

  def index
    # get_id returns user id, by which we will get restaurant_id and take dishes form there
    @restaurant = Restaurant.find(get_id)
    @get_role = get_role
  end

  def new
    @restaurant = Restaurant.find(get_id)
    @dish = Dish.new
  end

  def create
    dish = Dish.new dish_params.merge(restaurant_id: get_id)

    if dish.save
      redirect_to restaurant_dishes_path
    else
      flash[:notice] = dish.errors.full_messages.join("\n")
      redirect_to new_restaurant_dish_path
    end
  end

  def show
    @dish = Dish.unscoped.find(params[:id])
    @rest_id = get_id if get_role == "Restaurant"
    @role = get_role
    @restaurant = Restaurant.find(get_id) if get_role == "Restaurant"
    render layout: "application" unless @rest_id
  end

  def edit
    @restaurant = Restaurant.find(get_id)
    @dish = Dish.unscoped.find(params[:id])
  end

  def update
    dish = Dish.unscoped.find(params[:id])
    if params[:requestType] == "Status-Update"
      if dish.In_Stock?
        dish.Out_Of_Stock!
      else
        dish.In_Stock!
      end
      flash[:notice] = "Dish Updated Sucessfully."
    else
      if dish.update dish_params
        flash[:notice] = "Dish Updated Sucessfully."
      else
        flash[:notice] = "Dish cannot be Updated!"
      end
      redirect_to restaurant_dish_path(dish)
    end
  end

  def destroy
    dish = Dish.unscoped.find(params[:id])
    dish.destroy
    flash[:notice] = "Dish Successfully deleted."
    redirect_to root_path
  end

  private
  def check_role
    unless get_role == "Restaurant"
      flash[:notice] = "Kindly Login with Restaurant ID"
      redirect_to new_auth_path
    end
  end

  def dish_params
    params.expect(dish: [ :name, :description, :price, :category, :image ])
  end
end
