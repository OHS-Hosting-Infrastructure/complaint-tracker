require "fake_api_response_wrapper"
require "fake_issues"

module Api::Hses
  def request
    Rails.logger.debug <<~EODM
      HSES #{path}:
      #{response.inspect}
    EODM
    if response.failed?
      Rails.logger.error "HSES call to #{path} responded with #{response.code}"
    end
    response
  end

  def error_type
    Api::ErrorHses
  end

  def host
    Rails.configuration.x.hses.api_hostname
  end

  private

  def configure_auth(request)
    request.basic_auth(
      Rails.configuration.x.hses.api_username,
      Rails.configuration.x.hses.api_password
    )
  end

  def parameters
    {}
  end
end

class Api::Hses::Issue < ApiRequest
  include Api::Hses
  attr_accessor :id

  def initialize(id:)
    @id = id
  end

  private

  def path
    "/issues-ws/issue/#{id}"
  end
end

class Api::Hses::Issues < ApiRequest
  include Api::Hses

  PAGE_LIMIT = 25

  def initialize(user:, params: {})
    @username = user["uid"]
    @page = params.fetch(:page, 1)
    @sort = params.fetch(:sort, "-creationDate")
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
      limit: PAGE_LIMIT,
      sort: @sort
    }
  end

  def path
    "/issues-ws/issues"
  end
end

class Api::Hses::Grantee < ApiRequest
  include Api::Hses
  attr_accessor :id

  def initialize(id:)
    @id = id
  end

  private

  def path
    "/issues-ws/grantee/#{id}"
  end
end
