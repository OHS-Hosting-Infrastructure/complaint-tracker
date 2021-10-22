class ApiResponse
  attr_reader :code
  attr_accessor :error

  def initialize(response)
    @response = response
    @code = response.code.to_i
    @response_body = response.body
    @error = Api::Error.new(@code, body: body) if failed?
  end

  def body
    @body ||= parse_body
  end

  def count
    succeeded? ? 1 : 0
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

  def parse_body
    JSON.parse(@response_body).with_indifferent_access
  rescue JSON::ParserError
    Rails.logger.error("Error parsing response body: \"#{@response_body}\"")
    {}
  end
end
