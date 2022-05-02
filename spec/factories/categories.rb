FactoryBot.define do
  factory :category do
    title       {Faker::Lorem.characters(number: 5)}
    color_id    {Faker::Number.between(from: 1, to: 10)}
    association :user
  end
end