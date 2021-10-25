require "api_response"
require "fake_api_response_wrapper"
require "fake_issues"

class Api::FakeData::Hses
  def initalize(**)
  end

  class Issue
    include FakeApiResponseWrapper
    attr_accessor :id

    def initialize(id:)
      @id = id
    end

    def request
      details_response(FakeIssues.instance.data.find { |c| c[:id] == @id })
    end
  end

  class Issues
    include FakeApiResponseWrapper

    def initialize(user:, params: {})
      @username = user[:uid]
      # note: this parameter is used for viewing possible errors with responses
      @error_code = params[:error]
    end

    def request
      case @error_code
      when "400"
        # NOTE: this is what they actually send but does not
        # match the HSES API spec
        other_response(400, '{
          "status": "400",
          "error": "Bad Request",
          "message": "HSES error message saying bad request"
        }')
      when "401"
        other_response(401, '{
          "status": "401",
          "error": "Unauthorized",
          "message": "HSES error message saying user is unauthorized"
        }')
      when "403"
        other_response(403, '{
          "status": "403",
          "error": "Remote IP is not allowed",
          "message": "HSES error message saying remote IP not allowed"
        }')
      when "500"
        other_response(500, '{
          "status": "500",
          "error": "Unexpected error",
          "message": "HSES unexpected error message"
        }')
      else
        list_response(FakeIssues.instance.data)
      end
    end
  end

  class Grantee
    include FakeApiResponseWrapper
    attr_accessor :id

    def initialize(id:)
      @id = id
    end

    def request
      details_response(Api::FakeData::Grantee.new(id: id).data)
    end
  end
end
