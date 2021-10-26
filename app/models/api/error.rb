module Api
  class Error < StandardError
    attr_reader :code

    def initialize(code, body = {})
      @body = body
      @code = code
      # pass detailed message to StandardError initialize
      super details
    end

    def details
      @body[:message] || title
    end

    def title
      @title ||= @body[:error] || default_title
    end

    private

    def default_title
      # if no title found, use default http status code message
      codes = Rack::Utils::HTTP_STATUS_CODES
      codes.key?(@code) ? codes[@code] : "Something went wrong"
    end
  end
end
