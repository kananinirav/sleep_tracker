# frozen_string_literal: true

# A SleepTracking belongs to a User.
class SleepTracking < ApplicationRecord
  belongs_to :user

  validates :clock_in, presence: true
end
