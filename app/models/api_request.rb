class ApiRequest
  def response
    @response ||= get_response
  end

  private

  def format_response(res)
    {
      success: res.code == "200",
      code: res.code.to_i,
      body: JSON.parse(res.body)
    }.with_indifferent_access
  end

  def get_response
    format_response(send_api_request)
  end

  # Inheriting class defines
  def host
    raise "Please define a host method in #{self.class}"
  end

  # Inheriting class defines
  def path
    raise "Please define a path method in #{self.class}"
  end

  # Inheriting class defines
  def query
    raise "Please define a query method in #{self.class}"
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
    @uri ||= if use_ssl?
      URI::HTTPS.build(
        host: host,
        port: port,
        path: path,
        query: query
      )
    else
      URI::HTTP.build(
        host: host,
        port: port,
        path: path,
        query: query
      )
    end
  end

  # NOTE: this will need refactoring if we connect to multiple APIs
  def send_api_request
    req = Net::HTTP::Get.new(request_uri)

    configure_auth(req)

    Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: use_ssl?) do |http|
      http.request(req)
    end
  end
end
