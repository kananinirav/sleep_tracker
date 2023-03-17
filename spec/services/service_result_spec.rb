# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceResult do
  describe '#initialize' do
    it 'sets the service name' do
      result = ServiceResult.new('Test Service')
      expect(result.service_name).to eq('Test Service')
    end

    it 'initializes with an empty errors array' do
      result = ServiceResult.new('My Service')
      expect(result.errors).to be_empty
    end

    it 'initializes with is_success set to true' do
      result = ServiceResult.new('Test Service')
      expect(result.is_success).to be_truthy
    end
  end

  describe '#data' do
    it 'can be set and retrieved' do
      result = ServiceResult.new('My Service')
      result.data = { data: 'return data object or array' }
      expect(result.data).to eq({ data: 'return data object or array' })
    end
  end

  describe '#errors' do
    it 'can be set and retrieved' do
      result = ServiceResult.new('My Service')
      result.errors = ['spec test error']
      expect(result.errors).to eq(['spec test error'])
    end
  end
end
