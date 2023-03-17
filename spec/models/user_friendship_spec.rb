# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserFriendship, type: :model do
  describe 'associations' do
    it { should belong_to(:follower_user).class_name('User') }
    it { should belong_to(:following_user).class_name('User') }
  end
end
