# frozen_string_literal: true

# The ApplicationController class inherits from ActionController::API and includes the ApiResponse
# module
class ApplicationController < ActionController::API
  include ApiResponse

  def current_user
    @current_user ||= User.find(params[:user_id])
  end
end
