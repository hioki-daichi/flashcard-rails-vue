FactoryBot.define do
  factory :page do
    association :book
    sequence(:position) { |n| n }
    question { Faker::Lorem.sentence }
    answer { Faker::Lorem.sentence }
  end
end
