FactoryBot.define do
  factory :spend do
    money     {1000}
    day       {Date.today}
    memo      {Faker::Lorem.sentence}
    association :user
    association :category
  end
end