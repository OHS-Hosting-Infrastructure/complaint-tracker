class ApiResponseCollection < ApiResponse
  def count
    body.dig(:meta, :itemTotalCount) || 0
  end

  def data
    succeeded? ? body[:data] : []
  end
end
