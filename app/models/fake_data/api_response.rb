class FakeData::ApiResponse
  def self.generate_hses_issues_response
    complaints = 25.times.map { |complaint| FakeData::Complaint.new.data }
    jsonapi_list_wrapper.merge(data: complaints)
  end

  def self.hses_issues_response
    @issues_response ||= generate_hses_issues_response
  end

  def self.hses_issue_response(id)
    complaint = hses_issues_response[:data].find { |c| c[:id] == id }
    jsonapi_details_wrapper.merge(data: complaint)
  end

  def self.generate_hses_issue_response
    jsonapi_details_wrapper.merge(data: FakeData::Complaint.new.data)
  end

  def self.jsonapi_list_wrapper
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

  def self.jsonapi_details_wrapper
    {
      data: {},
      included: []
    }
  end
end
