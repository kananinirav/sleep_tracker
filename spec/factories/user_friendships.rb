FactoryBot.define do
  factory :user_friendship do
    association :follower_user, factory: :user
    association :following_user, factory: :user
  end
end
