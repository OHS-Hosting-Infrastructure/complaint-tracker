require "fake_api_response_wrapper"

class Api::FakeData::Tta
  class ActivityReport
    include FakeApiResponseWrapper
    attr_accessor :display_id

    def initialize(display_id:, access_token:)
      @display_id = display_id
    end

    def request
      case display_id
      when /-401\z/
        {
          success: false,
          code: 401,
          body: {
            status: "401",
            title: "Unauthenticated User",
            detail: "User token is missing or did not map to a known user"
          }
        }
      when /-403\z/
        {
          success: false,
          code: 403,
          body: {
            status: "403",
            title: "Unauthorized User",
            details: "User does not have the appropriate permissions to view this resource"
          }
        }
      when /-404\z/
        {
          success: false,
          code: 404,
          body: {
            status: "404",
            title: "Not Found",
            details: "Report #{display_id} could not be found"
          }
        }
      else
        {
          success: true,
          code: 200,
          body: details_wrapper.merge(
            data: Api::FakeData::ActivityReport.new(display_id: display_id).data
          )
        }
      end
    end
  end
end
