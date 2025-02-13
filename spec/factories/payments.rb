FactoryBot.define do
  factory :payment do
    client { create :client }
    amount { rand(1 ... 1000) }
    payment_method { "card" }
    payment_intent_id { Faker::Alphanumeric.alpha }
    status { [ "paid", "failed" ][rand (0 .. 1)] }
    paid_at { Time.now if status == "paid" }
    failed_at { Time.now if status != "paid" }
  end
end
