# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SleepTrackingManager do
  let(:user) { create(:user) }
  let(:options) { { actions: actions, current_user: user } }
  let(:service_result) { described_class.call(options) }
  let(:sleep_record) { user.sleep_trackings.last }

  describe '#call' do
    context 'when action is clock_in' do
      let(:actions) { 'clock_in' }

      it 'creates a new sleep record with clock_in time' do
        expect { service_result }.to change(user.sleep_trackings, :count).by(1)
        expect(sleep_record.clock_in).to be_present
      end

      context 'when there is already a sleep record with nil clock_out' do
        before { create(:sleep_tracking, user: user, clock_in: 2.hours.ago, clock_out: nil) }

        it 'does not create a new sleep record and returns an error message' do
          expect { service_result }.not_to change(user.sleep_trackings, :count)
          expect(service_result.data).to include(message: 'you need to clock out first')
        end
      end
    end

    context 'when action is clock_out' do
      let(:actions) { 'clock_out' }

      context 'when there is no sleep record' do
        it 'returns an error message' do
          expect(service_result.data).to include(message: 'you need to clock in first')
        end
      end

      context 'when there is a sleep record with clock_out' do
        before { create(:sleep_tracking, user: user, clock_in: 2.hours.ago, clock_out: 1.hour.ago) }

        it 'does not update the sleep record and returns an error message' do
          expect { service_result }.not_to change { sleep_record.reload.attributes }
          expect(service_result.data).to include(message: 'you need to clock in first')
        end
      end

      context 'when there is a sleep record with nil clock_out' do
        # before { user.sleep_trackings.create(clock_in: 2.hours.ago) }
        before { create(:sleep_tracking, user: user, clock_in: 2.hours.ago, clock_out: nil) }

        it 'updates the sleep record with clock_out time and sleep_duration' do
          expect { service_result }.to change { sleep_record.reload.clock_out }.from(nil).to(be_present)
          expect(sleep_record.sleep_duration).to eq((sleep_record.clock_out - sleep_record.clock_in).to_i)
          expect(service_result.data).to include(message: 'clocked out successfully')
        end
      end
    end
  end
end
