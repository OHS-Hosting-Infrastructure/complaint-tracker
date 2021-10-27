require "ffaker_wrapper"

class Api::FakeData::Review
  include FfakerWrapper
  attr_reader :id

  def initialize(id:)
    @id = id
  end

  def data
    @data ||= {
      id: id,
      type: "reviews",
      attributes: {
        status: review_status,
        grantNumbers: [grant_number, grant_number],
        reviewType: review_type,
        reviewStartDate: date_string,
        reviewEndDate: date_string,
        outcome: review_outcome
      },
      links: {
        self: "https://example.com/TODO",
        html: "https://example.com/TODO"
      }
    }
  end
end
