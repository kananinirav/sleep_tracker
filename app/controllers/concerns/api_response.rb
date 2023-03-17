# frozen_string_literal: true

# This is a module that is included in the ApplicationController. It is a way to DRY up the code in
# the controllers.
module ApiResponse
  def self.included(base)
    base.class_eval do
      # pass only permitted Parameters only
      ActionController::Parameters.action_on_unpermitted_parameters = :raise

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
      rescue_from ActionController::ParameterMissing, with: :unprocessable_entity
      rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters
    end
  end

  private

  ##
  # It renders a JSON response with a success key set to true, a message key set to the message
  # argument, and a data key set to the data argument
  #
  # Args:
  #   message: This is the message that you want to send to the client. Defaults to nil
  #   data: The data you want to send back to the client. Defaults to nil
  #   status: The HTTP status code to return. Defaults to :ok
  def success_response(message = nil, data = nil, status = :ok)
    render json: { success: true, message: message, data: data }, status: status
  end

  ##
  # It renders a JSON response with a success key set to false, a message key set to the message
  # argument, and an errors key set to the errors argument
  #
  # Args:
  #   message: This is the message that will be displayed to the user. Defaults to nil
  #   errors: An array of errors that occurred. Defaults to []
  #   status: The HTTP status code to return. Defaults to :unprocessable_entity
  def error_response(message = nil, errors = [], status = :unprocessable_entity)
    render json: { success: false, message: message, errors: errors }, status: status
  end

  def not_found
    error_response(nil, ['Record not found'])
  end

  ##
  # It takes the exception message and returns a JSON response
  #
  # Args:
  #   exception: The exception object that was raised.
  def unprocessable_entity(exception)
    error_response(nil, exception.record.errors.full_messages)
  end

  ##
  # It takes the exception message and returns a JSON response with a 400 status code
  #
  # Args:
  #   exception: The exception object that was raised.
  def unpermitted_parameters(exception)
    error_response(nil, [exception.message], :bad_request)
  end

  ##
  # It creates a response object from a service object
  #
  # Args:
  #   service_obj: The service object that you want to create a response from.
  #   status: The HTTP status code you want to return.
  def crete_response_from_service(service_obj, status)
    if service_obj.is_success
      success_response(service_obj.data[:message], service_obj.data[:data], status)
    else
      error_response(service_obj.data[:message], service_obj.data[:errors])
    end
  end
end
