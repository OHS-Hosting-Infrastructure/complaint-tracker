class ApiResponse
  attr_reader :code

  def initialize(response, error_type: Api::Error)
    @response = response
    @code = response.code.to_i
    @response_body = response.body
    @error_type = error_type
  end

  def body
    @body ||= parse_body
  end

  def count
    succeeded? ? 1 : 0
  end

  def error
    @error ||= create_error
  end

  def data
    succeeded? ? body[:data] : {}
  end

  def failed?
    !succeeded?
  end

  def succeeded?
    code == 200
  end

  private

  def create_error
    @error_type.new(@code, body: body) if failed?
  end

  def parse_body
    JSON.parse(@response_body).with_indifferent_access
  rescue JSON::ParserError
    Rails.logger.error("Error parsing response body: \"#{@response_body}\"")
    {}
  end
end
