require "api_request"
require "fake_api_response_wrapper"
require "fake_issues"

module Api::Hses
  def host
    Rails.configuration.x.hses.api_hostname
  end
end

class Api::Hses::Issue < ApiRequest
  include Api::Hses
  include FakeApiResponseWrapper
  attr_accessor :id

  def initialize(id:)
    @id = id
  end

  # TODO update this with real data once we have /issue endpoint
  def request
    fake_issue = FakeIssues.instance.json[:data].find { |c| c[:id] == id }
    details_wrapper.merge(
      data: (fake_issue || FakeIssues.instance.json[:data].last)
    )
  end
end

class Api::Hses::Issues < ApiRequest
  include Api::Hses
  def initialize(user:)
    @username = user["uid"]
  end

  def request
    response[:code] == "200" ? response[:body] : {}
  end

  private

  def path
    "/issues-ws/issues"
  end

  def query
    "username=#{@username}&types=1"
  end
end
