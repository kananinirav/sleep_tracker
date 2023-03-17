FactoryBot.define do
  factory :user do
    user_name { Faker::Internet.username(specifier: 5..10) }
  end
end
