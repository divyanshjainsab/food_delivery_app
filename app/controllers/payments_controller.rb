class PaymentsController < ApplicationController
  # before_action :validate_request, only: %i[ success cancel ]

  def create
    # Find the dish using the id parameter passed in the URL
    dish = Dish.find(params[:id])

    # Create a Stripe Checkout session for this specific dish
    @session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'inr',
          product_data: {
            name: dish.name,
          },
          unit_amount: (dish.price * 100).to_i,  # amount in cents
        },
        quantity: 1
      }],
      payment_intent_data: {
        "metadata":{
          client_id: get_id,
          dish_id: dish.id
        }
      },
      mode: 'payment',
      success_url: "#{request.base_url}/success/#{dish.id}",  # Full URL for success
      cancel_url: "#{request.base_url}/cancel",   # Full URL for cancel
    })

    # Return the session URL as JSON
    render json: { session_url: @session.url }
  end

  def cancel
  end
  
  def success
    payment = Payment.last
    dish = Dish.find(params[:dish_id])
    @order = Order.new payment: payment, client: payment.client, dish: dish
    if @order.save!
      UserMailer.order_confirmation(@order).deliver_now
      RestaurantMailer.received_order_email(@order).deliver_now

      # cancel order in 2 minutes if not prepared or dispatched
      CancelOrderIfNoRidersAssignedJob.set(wait: 2.minutes).perform_later @order
    else
      render
    end
  end


  private 
  def validate_request
    redirect_to "/404" unless params[:transaction_id] 
  end
end
