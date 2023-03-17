# frozen_string_literal: true

# common service result
class ServiceResult
  # get service name
  attr_reader :service_name

  # get is_success and set is_success
  attr_accessor :is_success

  # get data object/value and set is_success
  attr_accessor :data

  # get errors and set errors
  # it is array of CustomError class
  attr_accessor :errors

  def initialize(service_name)
    @service_name = service_name
    @errors = []
    @is_success = true
  end
end
