class RestaurantMailer < ApplicationMailer
    def received_order_email(order)
        @order = order
        mail(to: @order.dish.restaurant.user.email, subject: "Received a new Order!!!" ) 
    end
end
