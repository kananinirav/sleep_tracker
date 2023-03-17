# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SleepTracking, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:clock_in) }
  end
end
