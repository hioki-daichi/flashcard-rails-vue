FactoryBot.define do
  factory :book do
    association :user
    sequence(:row_order) { |n| n }
    sequence(:title) { |n| "#{Faker::Book.title} #{n}" }
  end
end
