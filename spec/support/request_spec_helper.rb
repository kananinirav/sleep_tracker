# frozen_string_literal: true

# RequestSpecHelper
module RequestSpecHelper
  def response_json
    JSON.parse(response.body)
  end
end
