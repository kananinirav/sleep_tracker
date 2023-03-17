# frozen_string_literal: true

# A User has many sleep_trackings, has many following_users, has many follower_users,
# and validates the presence of user_name
class User < ApplicationRecord
  has_many :sleep_trackings
  has_many :user_friendships, foreign_key: :follower_user_id
  has_many :following_users, through: :user_friendships

  has_many :user_following_friendships, foreign_key: :following_user_id, class_name: 'UserFriendship'
  has_many :follower_users, through: :user_following_friendships

  validates :user_name, presence: true

  scope :friends_last_week_sleep_trackings, lambda {
    includes(:sleep_trackings)
      .where(sleep_trackings: { created_at: 1.week.ago..Time.now })
      .where.not(sleep_trackings: { clock_out: nil })
      .order(sleep_duration: :desc)
  }
end
