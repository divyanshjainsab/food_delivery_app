FactoryBot.define do
  factory :order do
    client { create :client }
    dish { create :dish }
    payment { create :payment }
    status { %w[Processing Prepared Out_For_Delivery Delivered Rejected Cancelled][rand (0 .. 5)] }
  end
end
