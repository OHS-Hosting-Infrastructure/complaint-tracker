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
      @username = user["uid"]
    end

    def request
      list_response(FakeIssues.instance.data)
    end
  end
end
