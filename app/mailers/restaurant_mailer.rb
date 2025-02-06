class RestaurantMailer < ApplicationMailer
    def received_order_email(order)
        @order = order
        mail(to: @order.dish.restaurant.user.email, subject: "Received a new Order!!!" ) 
    end

    def order_cancellation(order)
        @order = order
        mail(to: @order.dish.restaurant.user.email, subject: "Order Cancelled." )
    end
    
    def order_cancellation_by_user(order)
        @order = order
        mail(to: @order.dish.restaurant.user.email, subject: "Order Cancelled." )
    end
    
    def order_status_update_prepared(order)
        @order = order
        mail(to: @order.client.user.email, subject: "Update on Order status" )
    end
end
