module Api
  class Error < StandardError
    attr_reader :status, :title

    def initialize(api_response)
      @response = api_response
      @status = api_response.code
      @title = get_title
      # pass detailed message to StandardError initialize
      super details
    end

    def body
      @body ||= @response.error_object
    end

    def details
      puts body
      body[:details] || body[:message] || title
    end

    def get_title
      body[:title] || body[:error] || default_title
    end

    private

    def default_title
      # if no title found, use default http status code message
      codes = Rack::Utils::HTTP_STATUS_CODES
      codes.key?(@status) ? codes[@status] : "Error with request"
    end
  end
end
