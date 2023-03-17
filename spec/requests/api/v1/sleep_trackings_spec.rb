# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::SleepTrackings', type: :request do
  let(:current_user) { create(:user) }

  def sleep_duration_hour(sleep_duration)
    "#{(sleep_duration / 3600).to_i}:#{(sleep_duration % 3600 / 60).to_i}:#{sleep_duration % 60}"
  end

  describe 'POST #clock_in' do
    context 'check in successful' do
      it 'clocks in the user' do
        post clock_in_api_v1_user_sleep_trackings_path(current_user.id), as: :json
        expect(response).to have_http_status(:ok)
        expect(current_user.sleep_trackings.count).to eq(1)
      end
    end

    context 'clocks in without clock out' do
      before { create(:sleep_tracking, user: current_user, clock_in: Time.zone.now, clock_out: nil) }

      it 'clocks in again without clock out' do
        post clock_in_api_v1_user_sleep_trackings_path(current_user.id), as: :json
        expected_response = {
          'success' => true,
          'message' => 'you need to clock out first',
          'data' => nil
        }
        expect(response).to have_http_status(:ok)
        expect(response_json).to eq(expected_response)
      end
    end
  end
  describe 'PATCH #clock_out' do
    context 'check in successful' do
      before { create(:sleep_tracking, user: current_user, clock_in: Time.zone.now, clock_out: nil) }

      it 'clocks in the user' do
        patch clock_out_api_v1_user_sleep_trackings_path(current_user.id), as: :json
        expect(response).to have_http_status(:ok)
        expect(current_user.sleep_trackings.last.clock_out).to be_present
      end
    end

    context 'clocks out without clock in' do
      it 'clocks out again without clock in' do
        patch clock_out_api_v1_user_sleep_trackings_path(current_user.id), as: :json
        response_json = {
          'success' => true,
          'message' => 'you need to clock in first',
          'data' => nil
        }
        expect(response).to have_http_status(:ok)
        expect(response_json).to eq(response_json)
      end
    end
  end

  describe 'GET #index' do
    let!(:current_user) { create(:user) }
    let!(:following_user1) { create(:user) }
    let!(:following_user2) { create(:user) }
    let!(:sleep_tracking1) do
      create(:sleep_tracking, user: following_user1, clock_in: 1.day.ago, clock_out: 1.day.ago + 8.hours)
    end
    let!(:sleep_tracking2) do
      create(:sleep_tracking, user: following_user2, clock_in: 2.day.ago, clock_out: 2.day.ago + 7.hours)
    end

    before do
      current_user.following_users << following_user1
      current_user.following_users << following_user2
    end

    it 'returns the friend sleep records for the last week' do
      get api_v1_user_sleep_trackings_path(current_user.id), as: :json
      expected_response = [
        {
          'user_id' => following_user1.id,
          'user_name' => following_user1.user_name,
          'sleep_trackings' => [
            {
              'id' => sleep_tracking1.id,
              'user_id' => following_user1.id,
              'clock_in' => I18n.l(sleep_tracking1.clock_in,
                                   format: :custom_format),
              'clock_out' => I18n.l(sleep_tracking1.clock_out,
                                    format: :custom_format),
              'sleep_duration_second' => sleep_tracking1.sleep_duration,
              'sleep_duration_hour' => sleep_duration_hour(sleep_tracking1.sleep_duration)
            }
          ]
        },
        {
          'user_id' => following_user2.id,
          'user_name' => following_user2.user_name,
          'sleep_trackings' => [
            {
              'id' => sleep_tracking2.id,
              'user_id' => following_user2.id,
              'clock_in' => I18n.l(sleep_tracking2.clock_in,
                                   format: :custom_format),
              'clock_out' => I18n.l(sleep_tracking2.clock_out,
                                    format: :custom_format),
              'sleep_duration_second' => sleep_tracking2.sleep_duration,
              'sleep_duration_hour' => sleep_duration_hour(sleep_tracking2.sleep_duration)
            }
          ]
        }
      ]
      expect(response_json['data']).to match_array(expected_response)
    end

    it 'when user friends data is not present' do
      get api_v1_user_sleep_trackings_path(following_user1.id), as: :json
      expected_response = {
        'success' => true,
        'message' => nil,
        'data' => []
      }
      expect(response_json).to eq(expected_response)
    end

    it 'when user not found' do
      get api_v1_user_sleep_trackings_path(123), as: :json
      expected_response = {
        'success' => false,
        'message' => nil,
        'errors' => ['Record not found']
      }
      expect(response_json).to match_array(expected_response)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
