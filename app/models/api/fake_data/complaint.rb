require "ffaker_wrapper"

class Api::FakeData::Complaint
  include FfakerWrapper

  def data
    @data ||= {
      id: identifier,
      type: "issues",
      attributes: {
        status: status_object,
        regarding: regarding,
        agencyId: random_int(999),
        grantNumber: grant_number,
        grantee: grantee_name,
        region: random_int(13),
        issueType: issue_type_object,
        summary: phrase,
        priority: priority_object,
        initialContactDate: date_string,
        dueDate: date_string,
        creationDate: datetime_string,
        issueLastUpdated: datetime_string,
        closedDate: datetime_string,
        reopenedDate: datetime_string
      },
      links: {
        self: "https://example.com/TODO",
        html: "https://example.com/TODO"
      }
    }
  end
end
