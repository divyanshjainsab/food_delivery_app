class Order < ApplicationRecord
    belongs_to :client
    belongs_to :dish
    belongs_to :payment
    belongs_to :rider, optional: true

    # validation
    enum :status, %i[ Processing Prepared Out_For_Delivery Delivered Rejected Cancelled ]
    validates :payment_id, presence: true, uniqueness: true 
end
