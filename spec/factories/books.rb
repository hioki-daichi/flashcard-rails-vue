FactoryBot.define do
  factory :book do
    association :user
    sequence(:row_order) { |n| n }
    title { Faker::Book.title }
  end
end
