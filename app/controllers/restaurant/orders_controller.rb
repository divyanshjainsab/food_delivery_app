class Restaurant::OrdersController < ApplicationController
    before_action :check_role
    include Pagy::Backend   

    def index
        restaurant = Restaurant.find get_id
        @pagy, @orders = pagy(restaurant.orders.order(created_at: :desc), items: 10)
    end
    
    def show
        # @orders = restaurant.orders
    end

    # edit aka Mark as Prepared
    def edit
        order = Order.find(params[:id])
        order.update(status: "Prepared")
        RestaurantMailer.order_status_update_prepared(order).deliver_now
        flash[:message] = "Order with ID: #{order.id} successfully updated."
        redirect_to restaurant_orders_path 
    end

    def show
        @order = Order.find params[:id]
    end
    
    def destroy
        order = Order.find(params[:id])
        order.update(status: "Cancelled")
        RestaurantMailer.order_cancellation(order).deliver_now
        flash[:message] = "Order with ID: #{order.id} successfully Cancelled."
        redirect_to restaurant_orders_path 
    end

    private
    def check_role
        unless get_role == "Restaurant"
            flash[:notice] = "Login With Restaurant ID"
            redirect_to new_auth_path 
        end
    end
end
