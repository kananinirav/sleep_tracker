# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserManager do
  describe '#call' do
    context 'when creating a new user' do
      context 'when the user is saved successfully' do
        let(:user_obj) { build(:user, user_name: 'test1') } # Using FactoryBot to create a user object
        let(:options) { { actions: 'create', user_obj: user_obj } }
        let(:service_result) { described_class.call(options) }
        it 'returns a ServiceResult with success status and data' do
          expect(service_result.is_success).to eq true
          expect(service_result.data).to include(message: 'User successfully created', data: user_obj)
        end
      end

      context 'when the user is not saved successfully' do
        let(:user_obj) { build(:user, user_name: '') } # Using FactoryBot to create a user object
        let(:options) { { actions: 'create', user_obj: user_obj } }
        let(:service_result) { described_class.call(options) }

        it 'returns a ServiceResult with failure status and error messages' do
          expect(service_result.is_success).to eq false
          expect(service_result.data).to include(message: 'Please check required fields', errors: user_obj.errors.full_messages)
        end
      end
    end
  end
end
