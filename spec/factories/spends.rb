FactoryBot.define do
  factory :spend do
    money     {1000}
    day       {Date.today}
    memo      {Faker::Lorem.characters(number: 10)}
    association :user
    association :category
  end
end