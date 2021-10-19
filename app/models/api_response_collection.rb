class ApiResponseCollection < ApiResponse
  def count
    body.dig(:meta, :itemTotalCount) || 0
  end

  def data
    body[:data] || []
  end
end
