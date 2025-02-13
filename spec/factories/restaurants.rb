FactoryBot.define do
  factory :restaurant do
    category { [ 0, 1 ][rand(0 .. 1)] }
    fssai_licence { [ "15/#{Faker::Number.number(digits: rand(4..10))}", "100#{Faker::Number.number(digits: rand(4..10))}" ].sample }
  end
end
