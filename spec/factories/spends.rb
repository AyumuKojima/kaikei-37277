FactoryBot.define do
  factory :spend do
    money     {Faker::Number.number(digits: 5)}
    day       {Date.today}
    memo      {Faker::Lorem.characters(number: 10)}
    association :user
    association :category
  end
end