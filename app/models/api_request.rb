class ApiRequest
  def request_uri
    URI::HTTPS.build(
      host: host,
      path: path,
      query: query
    )
  end

  def response
    uri = request_uri
    res = send_api_request(uri)
    format_response(res)
  end

  private

  def format_response(res)
    {
      code: res.code,
      body: JSON.parse(res.body)
    }.with_indifferent_access
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

  # NOTE: this will need refactoring if we connect to multiple APIs
  def send_api_request(uri)
    req = Net::HTTP::Get.new(uri)
    req.basic_auth(
      Rails.configuration.x.hses.api_username,
      Rails.configuration.x.hses.api_password
    )

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
  end
end
