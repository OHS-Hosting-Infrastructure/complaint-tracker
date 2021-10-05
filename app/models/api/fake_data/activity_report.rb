require "ffaker_wrapper"

class Api::FakeData::ActivityReport
  include FfakerWrapper
  attr_reader :display_id

  def initialize(display_id:)
    @display_id = display_id
  end

  def data
    @data ||= {
      id: identifier,
      attributes: {
        display_id: display_id,
        startDate: datetime_string
      },
      links: {
        self: "https://example.com/TODO",
        html: "https://example.com/TODO"
      }
    }
  end
end
