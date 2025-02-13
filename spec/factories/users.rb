FactoryBot.define do
  factory :user do
    entryable_type { nil }
    entryable_id { nil }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    password_confirmation { password }
    phone { Faker::PhoneNumber.cell_phone_in_e164.sub(/^(\+?91)(\d{10})$/, '+91-\2') }
    address { Faker::Address.street_address.ljust(24, ' ') }
    name { Faker::Name.name }
    verified_tag { true }
  end
end
