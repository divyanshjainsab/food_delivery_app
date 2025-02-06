class Order < ApplicationRecord
    enum :status, %i[ Processing Prepared Out_For_Delivery Delivered Rejected Cancelled ]
    belongs_to :client
    belongs_to :dish
    belongs_to :payment

    # validation
    validates :payment_id, presence: true, uniqueness: true 
end
