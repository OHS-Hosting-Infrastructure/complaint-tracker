class ApiRequest
  PAGE_LIMIT = 25

  def response
    @response ||= get_response
  end

  private

  def default_params
    [
      "username=#{@username}",
      page_limit,
      page_offset
    ]
  end

  def format_response(res)
    {
      code: res.code,
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

  def page_limit
    "page[limit]=#{PAGE_LIMIT}" if @page
  end

  def page_offset
    if @page
      offset = (@page.to_i - 1) * PAGE_LIMIT
      "page[offset]=#{offset}"
    end
  end

  # Inheriting class defines
  def path
    raise "Please define a path method in #{self.class}"
  end

  # Inheriting class defines
  def parameters
    raise "Please define a parameters method in #{self.class}"
  end

  def query
    req_params = default_params + parameters
    req_params.compact.join("&")
  end

  def request_uri
    @uri ||= URI::HTTPS.build(
      host: host,
      path: path,
      query: query
    )
  end

  # NOTE: this will need refactoring if we connect to multiple APIs
  def send_api_request
    req = Net::HTTP::Get.new(request_uri)
    req.basic_auth(
      Rails.configuration.x.hses.api_username,
      Rails.configuration.x.hses.api_password
    )

    Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: true) do |http|
      http.request(req)
    end
  end
end
