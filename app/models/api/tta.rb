module Api::Tta
  def error_type
    Api::TtaError
  end

  def host
    Rails.configuration.x.tta.api_hostname
  end

  def port
    Rails.configuration.x.tta.api_port
  end

  def use_ssl?
    Rails.configuration.x.tta.use_ssl
  end

  def configure_auth(request)
    request["Authorization"] = "Bearer #{access_token.bearer_token}"
  end
end

class Api::Tta::ActivityReport < ApiRequest
  include Api::Tta
  attr_accessor :display_id, :access_token

  def initialize(display_id:, access_token:)
    @display_id = display_id
    @access_token = access_token
  end

  def request
    Rails.logger.debug <<~EODM
      TTAHub #{path}:
      #{JSON.pretty_generate(response)}
    EODM
    if response.failed?
      Rails.logger.error "TTA Hub call to #{path} responded with #{response.code}"
    end
    response
  end

  private

  def path
    "/api/v1/activity-reports/display/#{display_id}"
  end

  def parameters
    {}
  end
end
