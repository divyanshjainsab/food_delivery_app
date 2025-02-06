class UserMailer < ApplicationMailer
  
  def account_creation_verification_mail
    @otp = params[:otp]
    @user = params[:user]
    mail(to: @user.email, subject: "Account creation request @ food.Delivery.com" )
  end

  def account_creation_confirmation_mail
    @user = params[:user]
    mail(to: @user.email, subject: "Your account is successfully created with role of #{@user.entryable_type}" )
  end

  def payment_received(client, payment, dish)
    @client = client
    @payment = payment
    @dish = dish
    mail(to: @client.user.email, subject: "Update on the Payment status" )
  end

  def payment_failed(client, payment, dish)
    @client = client
    @payment = payment
    @dish = dish
    mail(to: @client.user.email, subject: "Update on the Payment status" )
  end
  
  def order_confirmation(order)
    @order = order
    mail(to: @order.client.user.email, subject: "Update on Order status" )
  end

  def order_status_update_delivery(order, delivery)
    @order = order
    @delivery = delivery
    mail(to: @order.client.user.email, subject: "Delivery Update" )
  end

  def order_cancellation(order)
    @order = order
    mail(to: @order.client.user.email, subject: "Order Cancelled." )
    end
end
