require 'rails_helper'

RSpec.describe ApplicationService, type: :model do
  describe '.call' do
    it 'instantiates a new instance of the service and calls the #call method' do
      options = { params: 'Test Call' }
      expect { ApplicationService.call(options) }.to raise_error(NotImplementedError)
    end
  end

  describe '#initialize' do
    it 'raises a NotImplementedError if not overridden in a subclass' do
      expect { ApplicationService.call }.to raise_error(ArgumentError)
    end
  end
end
