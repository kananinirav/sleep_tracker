# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserFriendshipManager do
  let(:following_user) { create(:user) }
  let(:current_user) { create(:user) }
  let(:service_result) do
    described_class.call(actions: action, following_user_id: following_user.id, current_user: current_user)
  end

  describe '#follow' do
    let(:action) { 'follow' }
    context 'when the user is not already following the given user' do
      it 'adds the given user to the current user\'s following_users' do
        expect { service_result }.to change { current_user.following_users.count }.from(0).to(1)
      end

      it 'returns a success message' do
        expect(service_result.data).to eq({ message: "#{current_user.user_name} started following to #{following_user.user_name} " })
      end
    end

    context 'when the user is already following the given user' do
      before { current_user.following_users << following_user }

      it 'does not add the given user to the current user following_users' do
        expect { service_result }.not_to change { current_user.following_users.count }
      end

      it 'returns an error message' do
        expect(service_result.data).to eq({ message: "#{current_user.user_name} Already following to #{following_user.user_name}" })
      end
    end

    context 'when the given user does not exist' do
      let(:following_user) { build(:user, id: 123) }

      it 'does not remove the given user from the current user following_users' do
        expect { service_result }.not_to change { current_user.following_users.count }
      end

      it 'returns an error message' do
        expect(service_result.data).to eq({ message: 'Following User not found' })
      end
    end
  end

  describe '#unfollow' do
    let(:action) { 'un-follow' }

    context 'when the given user exists' do
      context 'when the current user is following the given user' do
        before { current_user.following_users << following_user }

        it 'removes the given user from the current user following_users' do
          expect { service_result }.to change { current_user.following_users.count }.from(1).to(0)
        end

        it 'returns a success message' do
          expect(service_result.data).to eq({ message: "#{current_user.user_name} un-following #{following_user.user_name}" })
        end
      end

      context 'when the current user is not following the given user' do
        it 'does not remove the given user from the current user following_users' do
          expect { service_result }.not_to change { current_user.following_users.count }
        end

        it 'returns an error message' do
          expect(service_result.data).to eq({ message: "#{current_user.user_name} not following #{following_user.user_name}" })
        end
      end
    end

    context 'when the given user does not exist' do
      let(:following_user) { build(:user, id: 123) }

      it 'does not remove the given user from the current user following_users' do
        expect { service_result }.not_to change { current_user.following_users.count }
      end

      it 'returns an error message' do
        expect(service_result.data).to eq({ message: 'Following User not found' })
      end
    end
  end
end
