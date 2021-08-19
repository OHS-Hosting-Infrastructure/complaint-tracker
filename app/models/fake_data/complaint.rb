require "ffaker_wrapper"
class FakeData::Complaint
  include FfakerWrapper

  def data
    @data ||= {
      id: identifier,
      type: "issues",
      attributes: {
        issueLastUpdated: datetime_string,
        creationDate: datetime_string,
        closedDate: datetime_string,
        reopenedDate: datetime_string,
        initialContactDate: datetime_string,
        type: random_int(2),
        otherType: word,
        issue: phrase,
        priority: random_int,
        status: random_int(4),
        dueDate: date,
        grantee: grantee_name
      },
      relationships: {
        grantAward: {
          meta: {
            id: identifier
          }
        },
        grantProgram: {
          meta: {
            id: identifier
          }
        },
        region: {
          meta: {
            id: identifier
          }
        }
      },
      links: {
        self: "https://example.com/TODO",
        html: "https://example.com/TODO"
      }
    }
  end
end
