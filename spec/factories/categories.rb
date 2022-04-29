FactoryBot.define do
  factory :category do
    title       {"食費"}
    color_id    {1}
    association :user
  end
end