FactoryGirl.define do
  factory :weather do
    city { Faker::Name.name }
    country { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    temp { Faker::Number.decimal(3, 3) }
    pressure { Faker::Number.decimal(4, 2) }
    humidity { Faker::Number.decimal(2) }
    wind { Faker::Number.decimal(1, 2) }
  end
end
