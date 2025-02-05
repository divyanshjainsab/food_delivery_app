class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  # This action will be called by Stripe to handle various webhook events
  def receive
    # Log incoming event for debugging purposes
    Rails.logger.info("Received Stripe event: #{params.to_unsafe_h.inspect}")
    
    # Construct Stripe event object from the request params
    event = Stripe::Event.construct_from(params.to_unsafe_h)

    # Handle the event based on its type
    begin
      case event.type
      when "charge.succeeded"
        handle_payment_succeeded(event.data.object)
      when 'payment_intent.payment_failed'
        handle_payment_failed(event.data.object)
      else
        Rails.logger.warn("Unhandled event type: #{event.type}")
        # Optionally, you can raise an error here or just ignore unhandled events
      end
    rescue StandardError => e
      # Log error and return a response indicating failure
      Rails.logger.error("Error processing Stripe webhook: #{e.message}")
      render json: { error: "Webhook processing failed" }, status: :unprocessable_entity
    end

    # Respond with a success message to Stripe to acknowledge receipt of the event
    head :ok
  end

  private

  # Handle successful payment event
  def handle_payment_succeeded(payment_intent)
    client =  Client.find(payment_intent[:metadata][:client_id])
    dish =  Dish.find(payment_intent[:metadata][:dish_id])

    # Create a new payment record
    payment = Payment.create(
      client: client,
      amount: payment_intent.amount / 100,
      payment_method: payment_intent.payment_method,
      payment_intent_id: payment_intent.id,
      status: payment_intent.status,
      paid_at: Time.at(payment_intent.created)
    )
    # Send a confirmation email to the user
    UserMailer.payment_received(client, payment, dish).deliver_now
    Rails.logger.info("Payment succeeded for client #{client.id} with amount #{payment.amount}")
  rescue StandardError => e
    Rails.logger.error("Error handling payment succeeded webhook: #{e.message}")
  end

  # Handle failed payment event
  def handle_payment_failed(payment_intent)
    client =  Client.find(payment_intent[:metadata][:client_id])
    dish =  Dish.find(payment_intent[:metadata][:dish_id])

    # Create a new payment record to reflect the failure
    payment = Payment.create(
      client: client,
      amount: payment_intent.amount / 100,
      payment_method: payment_intent.payment_method,
      payment_intent_id: payment_intent.id,
      status: payment_intent.status,
      failed_at: Time.at(payment_intent.created)
    )
    # Send a failure notification email to the user
    UserMailer.payment_failed(client, payment, dish).deliver_now
    Rails.logger.info("Payment failed for client #{client.id} with amount #{payment.amount}")
  rescue StandardError => e
    Rails.logger.error("Error handling payment failed webhook: #{e.message}")
  end
end
