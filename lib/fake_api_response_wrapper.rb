module FakeApiResponseWrapper
  def list_wrapper
    {
      meta: {
        pageNumber: 1,
        pageSize: 25,
        pageTotalCount: 1,
        itemTotalCount: 25
      },
      data: [],
      links: {
        self: "https://example.com/TODO",
        first: "https://example.com/TODO",
        last: "https://example.com/TODO",
        prev: "https://example.com/TODO",
        next: "https://example.com/TODO"
      },
      included: []
    }
  end

  def details_wrapper
    {
      data: {},
      included: []
    }
  end
end
