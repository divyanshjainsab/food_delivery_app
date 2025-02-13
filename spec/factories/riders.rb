FactoryBot.define do
  factory :rider do
    status { [ 0, 1 ][rand(0 .. 1)] }
    driving_licence { "DL-#{Faker::Number.number(digits: 2)}-#{Faker::Number.number(digits: 4)}-#{Faker::Number.number(digits: 6)}" }
    vehical_number { "DL-#{Faker::Number.number(digits: 2)}-AB-#{Faker::Number.number(digits: 4)}" }
    date_of_birth { Faker::Date.between(from: 18.years.ago.to_date, to: 70.years.ago.to_date) }
  end
end
