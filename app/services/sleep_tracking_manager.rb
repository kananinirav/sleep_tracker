# frozen_string_literal: true

# It's a service class that manages sleep tracking of a user
class SleepTrackingManager < ApplicationService
  def initialize(options)
    @actions = options[:actions]
    @current_user = options[:current_user]
    @service_result = ServiceResult.new('User Management')
  end

  def call
    case @actions
    when 'index'
      index
    when 'clock_in'
      clock_in
    when 'clock_out'
      clock_out
    end
    @service_result
  rescue => e
    Rails.logger.info e
  end

  # write all required private method to full-fill service call
  private

  ##
  # > If the last sleep record is present and the clock out time is nil, then return a message saying
  # you need to clock out first. Otherwise, create a new sleep record with the current time as the clock
  # in time, and return a message saying you clocked in successfully along with the saved records
  def clock_in
    last_sleep_record = @current_user.sleep_trackings.last
    if last_sleep_record.present? && last_sleep_record&.clock_out.nil?
      @service_result.data = { message: 'You need to clock out first' }
      return
    end

    @current_user.sleep_trackings.create(clock_in: Time.zone.now)
    saved_records = @current_user.sleep_trackings.order(created_at: :desc)
    @service_result.data = { message: 'Clocked in successfully', data: saved_records }
  end

  ##
  # If the last sleep record for the current user is present and the clock out time is nil, then update
  # the last sleep record with the current time as the clock out time and the sleep duration as the
  # difference between the clock_out time and the clock in time
  def clock_out
    last_sleep_record = @current_user.sleep_trackings.last
    if last_sleep_record.present? && last_sleep_record.clock_out.nil?
      current_time = Time.zone.now
      last_sleep_record.update!(clock_out: current_time, sleep_duration: (current_time - last_sleep_record.clock_in))
      service_response = { message: 'Clocked out successfully' }
    else
      service_response = { message: 'You need to clock in first' }
    end
    @service_result.data = service_response
  end

  def index
    friends_sleep_records = @current_user.following_users.friends_last_week_sleep_trackings

    sleep_data = friends_sleep_records.map do |friend|
      {
        user_id: friend.id,
        user_name: friend.user_name,
        sleep_trackings: sleep_trackings_json(friend.sleep_trackings)
      }
    end
    @service_result.data = { data: sleep_data }
  end

  ##
  # It takes an array of sleep_trackings and returns an array of hashes with the sleep_tracking's id,
  # user_id, clock_in, clock_out, sleep_duration_second, and sleep_duration_hour
  #
  # Args:
  #   sleep_trackings: the collection of sleep_trackings
  def sleep_trackings_json(sleep_trackings)
    sleep_trackings.map do |data|
      {
        id: data.id,
        user_id: data.user_id,
        clock_in: I18n.l(data.clock_in, format: :custom_format),
        clock_out: I18n.l(data.clock_out, format: :custom_format),
        sleep_duration_second: data.sleep_duration,
        sleep_duration_hour: second_to_hour(data.sleep_duration)
      }
    end
  end

  ##
  # It takes a number of seconds and returns a string in the format of hours:minutes:seconds
  #
  # Args:
  #   second: the number of seconds to convert
  def second_to_hour(second)
    "#{(second / 3600).to_i}:#{(second % 3600 / 60).to_i}:#{second % 60}"
  end
end
