# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:sleep_trackings) }
    it { should have_many(:user_friendships).with_foreign_key(:follower_user_id) }
    it { should have_many(:following_users).through(:user_friendships) }
    it {
      should have_many(:user_following_friendships).class_name('UserFriendship').with_foreign_key(:following_user_id)
    }
    it { should have_many(:follower_users).through(:user_following_friendships) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:user_name) }
  end
end
