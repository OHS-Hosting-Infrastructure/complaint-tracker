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
    succeeded? ? JSON.parse(@response_body).with_indifferent_access : {}
  end

  def data
    body[:data] || {}
  end
end
