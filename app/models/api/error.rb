module Api
  class Error < StandardError
    attr_reader :code, :title

    def initialize(code, body: {})
      @body = body
      @code = code
      @title = get_title
      # pass detailed message to StandardError initialize
      super details
    end

    def details
      @body[:message] || title
    end

    def get_title
      @body[:error] || default_title
    end

    private

    def default_title
      # if no title found, use default http status code message
      codes = Rack::Utils::HTTP_STATUS_CODES
      codes.key?(@code) ? codes[@code] : "Something went wrong"
    end
  end

  class TtaError < Error
    def details
      case @code
      when 403
        "You do not have permission to access this activity report."
      when 404
        "This number doesn't match any existing activity reports. Please double-check the number."
      else
        @body[:details] || "We're unable to look up reports in TTA Smart Hub right now. Please try again later."
      end
    end

    def get_title
      @body[:title] || default_title
    end
  end
end
