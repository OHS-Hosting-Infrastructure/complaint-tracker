module FakeApiResponseWrapper
  def list_wrapper
    {
      meta: {
        itemTotalCount: 25
      },
      data: []
    }
  end

  def details_wrapper
    {
      data: {}
    }
  end
end
