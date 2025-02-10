class UserMailer < ApplicationMailer
  
  def account_creation_verification_mail(user, otp)
    @otp = otp
    @user = user
    mail(to: @user.email, subject: "Account creation request @ food.Delivery.com" )
  end

  def account_creation_confirmation_mail(user)
    @user = user
    mail(to: @user.email, subject: "Your account is successfully created with role of #{@user.entryable_type}" )
  end

  def payment_received(client, payment, dish)
    @client = client
    @payment = payment
    @dish = dish
    mail(to: @client.email, subject: "Update on the Payment status" )
  end

  def payment_failed(client, payment, dish)
    @client = client
    @payment = payment
    @dish = dish
    mail(to: @client.email, subject: "Update on the Payment status" )
  end
  
  def order_confirmation(order)
    @order = order
    mail(to: @order.client.email, subject: "Update on Order status" )
  end

  def order_status_update_delivery(order, otp, delivery)
    @order = order
    @delivery = delivery
    @otp = otp
    mail(to: @order.client.email, subject: "Delivery Update" )
  end

  def order_delivered(order, email, rider)
    @order = order
    @rider = rider
    mail(to: email, subject: "Delivery Update" )
  end
  
  def order_cancellation(order)
    @order = order
    mail(to: @order.client.email, subject: "Order Cancelled." )
    end
end
