class ApiResponse
  attr_reader :code
  def initialize(response)
    @code = response.code.to_i
    @response_body = response.body
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

class ApiResponseCollection < ApiResponse
  def initialize(response)
    super
    @page_limit = 25.to_f
  end

  def count
    body.dig(:meta, :itemTotalCount) || 0
  end

  def data
    body[:data] || []
  end

  def page_total
    @page_total ||= (count.to_i / @page_limit).ceil
  end
end
