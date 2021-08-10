require "ffaker"

module FakeData::Complaints
  def self.data
    {
      id: FFaker::Random.rand(9999).to_s,
      type: "issues",
      attributes: {
        issueLastUpdated: FFaker::Time.date,
        creationDate: FFaker::Time.date,
        closedDate: FFaker::Time.date,
        reopenedDate: FFaker::Time.date,
        initialContactDate: FFaker::Time.date,
        type: FFaker::Random.rand(2),
        otherType: FFaker::Lorem.word,
        issue: FFaker::Lorem.phrase,
        priority: FFaker::Random.rand(3),
        status: FFaker::Random.rand(3),
        dueDate: FFaker::Time.date,
        # these just sound cool for use as the grantee name :)
        grantee: FFaker::AddressUK.street_name
      },
      relationships: {
        grantAward: {
          meta: {
            id: FFaker::Random.rand(9999).to_s
          }
        },
        grantProgram: {
          meta: {
            id: FFaker::Random.rand(999).to_s
          }
        },
        region: {
          meta: {
            id: FFaker::Random.rand(10).to_s
          }
        }
      },
      links: {
        self: "https://example.com/TODO",
        html: "https://example.com/TODO"
      }
    }
  end

  def self.generate_response
    json = jsonapi_wrapper
    25.times do |item|
      json[:data] << data
    end
    json
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
