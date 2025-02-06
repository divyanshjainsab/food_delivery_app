class Payment < ApplicationRecord
    belongs_to :client
    has_one :order

    # validations
    validates :payment_intent_id, presence: true, uniqueness: true
    
    
end
