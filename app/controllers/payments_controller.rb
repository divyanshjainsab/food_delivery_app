class PaymentsController < ApplicationController
  def create
    # Find the dish using the id parameter passed in the URL
    dish = Dish.find(params[:id])

    # Create a Stripe Checkout session for this specific dish
    @session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: dish.name,
          },
          unit_amount: (dish.price * 100).to_i,  # amount in cents
        },
        quantity: 1
      }],
      mode: 'payment',
      success_url: "#{request.base_url}/success",  # Full URL for success
      cancel_url: "#{request.base_url}/cancel",   # Full URL for cancel
    })

    # Return the session URL as JSON
    render json: { session_url: @session.url }
  end

  def cancel
  end

  def success
  end
end
