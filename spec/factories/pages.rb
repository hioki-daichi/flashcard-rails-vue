FactoryBot.define do
  factory :page do
    association :book
    sequence(:row_order) { |n| n }
    question { Faker::Lorem.sentence }
    answer { Faker::Lorem.sentence }
  end
end
