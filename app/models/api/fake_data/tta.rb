require "fake_api_response_wrapper"

class Api::FakeData::Tta
  class ActivityReport
    include FakeApiResponseWrapper
    attr_accessor :display_id

    def initialize(display_id:, access_token:)
      @display_id = display_id
    end

    # Api::FakeData::Tta::ActivityReport is set up to trigger various error states based on the
    # requested Display ID. When the last part of the display ID matches a well-known HTTP error code
    # that error code is returned instead of a successful report.
    def request
      case display_id
      when /-401\z/
        other_response(401, {
          status: "401",
          title: "Unauthenticated User",
          detail: "User token is missing or did not map to a known user"
        }.to_json)
      when /-403\z/
        other_response(403, {
          status: "403",
          title: "Unauthorized User",
          details: "User does not have the appropriate permissions to view this resource"
        }.to_json)
      when /-404\z/
        other_response(404, {
          status: "404",
          title: "Not Found",
          details: "Report #{display_id} could not be found"
        }.to_json)
      when /-500\z/
        other_response(500, "")
      else
        details_response(Api::FakeData::ActivityReport.new(display_id: display_id).data)
      end
    end
  end
end
