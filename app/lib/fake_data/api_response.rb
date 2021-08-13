require "ffaker"

module FakeData::ApiResponse
  def self.generate_hses_response
    complaints = 25.times.map { |complaint| FakeData::Complaint.new.data }
    jsonapi_wrapper.merge(data: complaints)
  end

  def self.jsonapi_wrapper
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
      }
    }
  end
end
