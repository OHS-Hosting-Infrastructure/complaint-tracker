require "api_response"

class ApiRequest
  def response
    @response ||= get_response
  end

  def response_type
    "ApiResponse"
  end

  private

  def get_response
    response_type.constantize.new(send_api_request)
  end

  # Inheriting class defines
  def host
    raise "Please define a host method in #{self.class}"
  end

  # Inheriting class defines
  def path
    raise "Please define a path method in #{self.class}"
  end

  # Inheriting class defines, should return hash
  def parameters
    raise "Please define a parameters method in #{self.class}"
  end

  def query
    URI.encode_www_form(parameters)
  end

  # Inheriting class defines
  def configure_auth(request)
    raise "Please define a configure_auth(request) method in #{self.class}"
  end

  # Optionally override this in the inheriting class
  def port
    443
  end

  # Optionally override this in the inheriting class
  def use_ssl?
    true
  end

  def request_uri
    @request_uri ||= build_uri
  end

  def build_uri
    uri_params = {
      host: host,
      port: port,
      path: path,
      query: query
    }
    use_ssl? ? URI::HTTPS.build(uri_params) : URI::HTTP.build(uri_params)
  end

  def send_api_request
    req = Net::HTTP::Get.new(request_uri)

    configure_auth(req)

    Net::HTTP.start(request_uri.hostname, request_uri.port, use_ssl: use_ssl?) do |http|
      http.request(req)
    end
  end
end
