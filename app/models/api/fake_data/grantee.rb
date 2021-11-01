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
        granteeName: grantee_name,
        grants: grants
      },
      links: {
        self: "https://example.com/self/TODO",
        html: "https://example.com/html/TODO"
      },
      relationships: {
        issues: {
          data: [
            Api::FakeData::Complaint.new.data,
            Api::FakeData::Complaint.new.data
          ]
        }
      }
    }
  end

  private

  def grants
    @grants ||= rand(1..3).times.map do
      grant
    end
  end

  def grant
    {
      id: identifier,
      type: "grants",
      attributes: {
        grantNumber: identifier,
        grantProgramStartDate: date_string,
        grantProgramEndDate: date_string,
        name: grantee_name,
        numberOfCenters: random_int(150),
        numberOfPrograms: random_int(5),
        region: region,
        totalComplaintsFiscalYear: [
          {
            fiscalYear: 2020,
            totalComplaints: random_int(5)
          },
          {
            fiscalYear: 2022,
            totalComplaints: random_int(5)
          },
          {
            fiscalYear: 2021,
            totalComplaints: random_int(5)
          }
        ]
      }
    }
  end

  def region
    @region ||= identifier
  end
end
