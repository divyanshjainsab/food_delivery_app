class Users::RidersController < ApplicationController
  before_action :check_access
  skip_before_action :check_access, only: [ :new, :create ]
  def new
    @rider = Rider.new
  end

  def create
    # creating an object of user, with rider_params
    user = User.new user_params(:rider).merge(entryable: (Rider.new rider_params), misc: Misc.new)

    # appC
    user = user_verification(user)
    # mail send to user

    # appC
    send_otp user if user

    # after handling user redirect to otp verification
  end

  def index
    @rider = Rider.find get_id
    if @rider.status == "Available"
      @orders = Order.Prepared
    else
      @order = Order.find session[:order_id]
    end
  end

  def pick_order
    rider = Rider.find get_id
    order = Order.find params[:order_id]
    session[:order_id] = order.id
    # this methods skips validations
    rider.update_column :status, "Busy" # rider is no more accepts order
    order.rider = rider # assign rider id to that order
    order.status = "Out_For_Delivery" # order status is updated
    order.save! # update the changes



    # send mail to user about delivery of order
    UserMailer.order_status_update_delivery(order, rider)

    # generate an otp and send to user
    send_delivery_otp

    # redirect to dashboard in order to refersh the page
    redirect_to rider_dashboard_path
  end

  def delivery
    otp = params[:otp].to_i
    order = Order.find session[:order_id]
    if order&.client&.user&.misc&.otp == otp
      rider = Rider.find get_id
      session.delete :order_id
      rider.update_column :status, "Available"
      order.update_column :status, "Delivered"
      # updated the status and send order delivery notification to both user and restaurant
      UserMailer.order_delivered(order, order.dish.restaurant.email, rider).deliver_now
      UserMailer.order_delivered(order, order.client.email, rider).deliver_now

      flash[:notice] = "Order Successfully delivered."
      redirect_to rider_dashboard_path

    else
      flash[:notice] = "Invalid Otp"
      redirect_to "/delivery"
    end
  end

  def delivery_view
  end

  def resend_delivery_otp
    send_delivery_otp
    flash[:notice] = "Otp Send successfully."
    redirect_to "/delivery"
  end

  private
   def rider_params
    params.require(:rider).require(:model).permit(%i[ driving_licence vehical_number date_of_birth ])
   end

   def check_access
    redirect_to root_path unless get_role == "Rider"
   end

   def send_delivery_otp
    order = Order.find session[:order_id]
    otp = rand(100000 .. 999999)
    order.client.user.misc.update_column :otp, otp
    rider = Rider.find get_id
    UserMailer.order_status_update_delivery(order, otp, rider).deliver_now
   end
end
