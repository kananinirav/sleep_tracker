# frozen_string_literal: true

# Base Service
class ApplicationService
  class << self
    def call(...)
      new(...).call
    end
  end

  def initialize(_args)
    raise NotImplementedError
  end

  def call
    raise NotImplementedError
  end
end
