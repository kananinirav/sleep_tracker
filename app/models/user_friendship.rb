# frozen_string_literal: true

# A UserFriendship belongs to a follower_user and a following_user, with class User
class UserFriendship < ApplicationRecord
  belongs_to :follower_user, class_name: 'User'
  belongs_to :following_user, class_name: 'User'
end
