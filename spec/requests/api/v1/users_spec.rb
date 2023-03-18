require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:current_user) { create(:user) }
  let(:following_user) { create(:user) }

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new user' do
        post api_v1_users_path, params: { user: { user_name: 'Test User' } }, as: :json
        expect(response).to have_http_status(:ok)
        expect(User.count).to eq(1)
        expect(User.first.user_name).to eq('Test User')
      end
    end

    context 'with invalid parameters' do
      it 'returns an error response' do
        post api_v1_users_path, params: { user: { user_name: '' } }, as: :json

        expected_response = {
          'success' => false,
          'message' => 'Please check required fields',
          'errors' => [
            "User name can't be blank"
          ]
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json).to eq(expected_response)
      end

      it 'returns an error for unpermitted parameters' do
        post api_v1_users_path, params: { user: { user_name: 'Test User', user_email: 'test@test.com' } }, as: :json

        expected_response = {
          'success' => false,
          'message' => nil,
          'errors' => [
            'found unpermitted parameter: :user_email'
          ]
        }
        expect(response).to have_http_status(:bad_request)
        expect(response_json).to eq(expected_response)
      end
    end
  end

  describe 'POST #follow' do
    context 'with valid parameters' do
      it 'creates a new user friendship' do
        post api_v1_user_follow_path(current_user.id, following_user.id), as: :json
        expect(response).to have_http_status(:ok)
        expect(UserFriendship.count).to eq(1)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error response' do
        post api_v1_user_follow_path(current_user.id, 0), as: :json
        expect(response).to have_http_status(:ok)
        expect(response_json).to eq({ 'success' => true, 'message' => 'Following User not found',
                                      'data' => nil })
      end
    end
  end

  describe 'DELETE #unfollow' do
    let!(:user_friendship) { create(:user_friendship, follower_user: current_user, following_user: following_user) }

    context 'with valid parameters' do
      it 'destroys the user friendship' do
        delete api_v1_user_unfollow_path(current_user.id, following_user.id), as: :json
        expect(response).to have_http_status(:ok)
        expect(UserFriendship.count).to eq(0)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error response' do
        delete api_v1_user_unfollow_path(following_user.id, 0), as: :json
        expect(response_json).to eq({ 'success' => true, 'message' => 'Following User not found',
                                      'data' => nil })
      end
    end
  end
end
