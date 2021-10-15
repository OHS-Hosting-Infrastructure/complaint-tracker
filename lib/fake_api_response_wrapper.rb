require "ostruct"

module FakeApiResponseWrapper
  def list_response(data)
    ApiResponse.new(
      OpenStruct.new(code: 200, body: list_wrapper.merge(data: data).to_json)
    )
  end

  def list_wrapper
    {
      meta: {
        itemTotalCount: 25
      },
      data: []
    }
  end

  def details_response(data)
    ApiResponse.new(
      OpenStruct.new(code: 200, body: details_wrapper.merge(data: data).to_json)
    )
  end

  def details_wrapper
    {
      data: {}
    }
  end

  def other_response(code, body)
    ApiResponse.new(
      OpenStruct.new(code: code, body: body)
    )
  end
end
