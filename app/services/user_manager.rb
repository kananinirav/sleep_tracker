# frozen_string_literal: true

# It's a service class that handles user management actions
class UserManager < ApplicationService
  def initialize(options)
    @actions = options[:actions]
    @user_obj = options[:user_obj]
    @service_result = ServiceResult.new('User Management')
  end

  def call
    case @actions
    when 'create'
      create
    end
    @service_result
  rescue => e
    Rails.logger.info e
  end

  # write all required private method to full-fill service call
  private

  def create
    if @user_obj.save
      @service_result.data = { message: 'User successfully created', data: @user_obj }
    else
      @service_result.is_success = false
      @service_result.data = { message: 'Please check required fields', errors: @user_obj.errors.full_messages }
    end
  end
end
