FactoryBot.define do
  factory :book do
    association :user
    sequence(:position) { |n| n }
    title { Faker::Book.title }
  end
end
