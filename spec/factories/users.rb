FactoryBot.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password { Faker::Lorem.characters(16) }
  end
end
