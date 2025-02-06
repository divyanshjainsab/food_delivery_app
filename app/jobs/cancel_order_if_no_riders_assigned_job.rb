class CancelOrderIfNoRidersAssignedJob < ApplicationJob
  queue_as :urgent

  def perform(order)
    if order.status == "Processing" || order.status == "Prepared" 
      order.update(status: 'Cancelled')
      RestaurantMailer.order_cancellation(order).deliver_now
    end
  end
end
