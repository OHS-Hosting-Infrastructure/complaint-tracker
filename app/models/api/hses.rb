require "api_request"
require "fake_api_response_wrapper"
require "fake_issues"

module Api::Hses
end

class Api::Hses::Issue < ApiRequest
  include FakeApiResponseWrapper
  attr_accessor :id

  def initialize(id:)
    @id = id
  end

  # TODO update this with real data once we have /issue endpoint
  def request
    details_wrapper.merge(
      data: FakeIssues.instance.json[:data].sample
    )
  end

  private

  def host
    Rails.configuration.x.hses.api_base
  end
end

class Api::Hses::Issues < ApiRequest
  def initialize(user:)
    @username = user["uid"]
  end

  def request
    res = response
    res[:code] == "200" ? res[:body] : {}
  end

  private

  def host
    Rails.configuration.x.hses.api_base
  end

  def path
    "/issues-ws/issues"
  end

  def query
    "username=#{@username}&types=1"
  end
end
