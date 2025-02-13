FactoryBot.define do
  factory :dish do
    restaurant { create :restaurant }
    name { Faker::Food.name }
    description { Faker::Food.description }
    price { rand(1 .. 1000) }
    category { rand(0 .. 1) }
  end
end
