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
      type: "activityReports",
      attributes: {
        author: tta_user_id_and_name_object,
        collaborators: [tta_user_id_and_name_object],
        displayId: display_id,
        duration: random_int(8),
        endDate: date_string,
        reason: ["Complaint"],
        region: random_int(13),
        reportCreationDate: datetime_string,
        reportLastUpdated: datetime_string,
        startDate: date_string,
        topics: [phrase, phrase]
      },
      links: {
        self: "https://example.com/TODO",
        html: "https://example.com/TODO"
      }
    }
  end
end
