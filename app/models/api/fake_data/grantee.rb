require "ffaker_wrapper"

class Api::FakeData::Grantee
  include FfakerWrapper

  def initialize(id:)
    @id = id
  end

  def data
    @data ||= {
      id: @id,
      type: "grantees",
      attributes: {
        grantNumber: identifier,
        grantProgramStartDate: date_string,
        grantProgramEndDate: date_string,
        name: grantee_name,
        numberOfCenters: random_int(150),
        numberOfPrograms: random_int(5),
        totalComplaintsFiscalYear: random_int(5),
        region: identifier
      },
      links: {
        self: "https://example.com/self/TODO",
        html: "https://example.com/html/TODO"
      },
      relationships: {
        issues: [
          { id: identifier },
          { id: identifier }          
        ]
      }
    }
  end
end
