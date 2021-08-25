require "fake_api_response_wrapper"
require "fake_issues"

class Api::Hses
  def initalize(**)
  end

  class Issue
    include FakeApiResponseWrapper
    attr_accessor :id

    def initialize(id:)
      @id = id
    end

    def request
      details_wrapper.merge(
        data: FakeIssues.instance.json[:data].find { |c| c[:id] == @id }
      )
    end
  end

  class Issues
    def request
      @issues ||= FakeIssues.instance.json
    end
  end
end
