# frozen_string_literal: true

# It's a controller to manage sleep tracking related actions.
class Api::V1::SleepTrackingsController < ApplicationController
  include Api::V1::SleepTrackingsControllerDoc

  def index
    service = SleepTrackingManager.call({ actions: 'index', current_user: current_user })
    crete_response_from_service(service)
  end

  ##
  # > Clock in the current user for sleep tracking.
  def clock_in
    service = SleepTrackingManager.call({ actions: 'clock_in', current_user: current_user })
    crete_response_from_service(service)
  end

  ##
  # > Clock out the current user for sleep tracking.
  def clock_out
    service = SleepTrackingManager.call({ actions: 'clock_out', current_user: current_user })
    crete_response_from_service(service)
  end
end
