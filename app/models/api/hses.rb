require "fake_api_response_wrapper"
require "fake_issues"

module Api::Hses
  def host
    Rails.configuration.x.hses.api_hostname
  end

  def configure_auth(request)
    request.basic_auth(
      Rails.configuration.x.hses.api_username,
      Rails.configuration.x.hses.api_password
    )
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
    fake_issue = FakeIssues.instance.data.find { |c| c[:id] == id }
    details_response(fake_issue || FakeIssues.instance.data.last)
  end
end

class Api::Hses::Issues < ApiRequest
  include Api::Hses

  PAGE_LIMIT = 25

  def initialize(user:, params: {})
    @username = user["uid"]
    @page = params[:page] || 1
  end

  def request
    Rails.logger.debug <<~EODM
      HSES #{path}:
      #{JSON.pretty_generate(response)}
    EODM
    if response.failed?
      Rails.logger.error "HSES call to #{path} responded with #{response.code}"
    end
    response
  end

  def response_type
    ApiResponseCollection
  end

  private

  def page_offset
    (@page.to_i - 1) * PAGE_LIMIT
  end

  def parameters
    {
      types: 1,
      username: @username,
      offset: page_offset,
      limit: PAGE_LIMIT
    }
  end

  def path
    "/issues-ws/issues"
  end
end
