class ApiResponse
  attr_reader :code
  def initialize(response)
    @code = response.code.to_i
    @response_body = response.body
  end

  def succeeded?
    code == 200
  end

  def failed?
    !succeeded?
  end

  def body
    succeeded? ? parse_body : {}
  end

  def data
    body[:data] || {}
  end

  def error_object
    failed? ? parse_body : {}
  end

  private

  def parse_body
    JSON.parse(@response_body).with_indifferent_access
  rescue JSON::ParserError
    Rails.logger.error("Error parsing response body: \"#{@response_body}\"")
    {}
  end
end
