class User::OrdersController < ApplicationController
    before_action :check_role

    include Pagy::Backend   

    def index
        client = Client.find get_id
        @pagy, @orders = pagy(client.orders.order(created_at: :desc), items: 10)
    end

    def show
        @order = Order.find params[:id]
        check_access(@order)
    end

    def destroy
        order = Order.find params[:id]
        order.update(status: "Cancelled")
        UserMailer.order_cancellation(order).deliver_now
        RestaurantMailer.order_cancellation_by_user(order).deliver_now
        flash[:message] = "Order with ID: #{order.id} successfully Cancelled."
        redirect_to user_orders_path
    end

    private
    def check_access(order)
        redirect_to user_orders_path if get_id != order.client.id
    end

    def check_role
        if get_role == nil
            flash[:notice] = "Login first!"
            redirect_to new_auth_path 
        elsif get_role != "Client"
            redirect_to root_path
        end
    end
end
