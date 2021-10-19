require "ffaker_wrapper"

class Api::FakeData::ActivityReport
  include FfakerWrapper
  attr_reader :display_id

  def initialize(display_id:)
    @display_id = display_id
  end

  def data
    @data ||= {
      id: id,
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
        self: "https://ttahub.ohs.acf.hhs.gov/api/v1/activity-reports/display/#{display_id}",
        html: "https://ttahub.ohs.acf.hhs.gov/activity-reports/view/#{id}"
      }
    }
  end

  private

  def id
    @id ||= identifier
  end
end
