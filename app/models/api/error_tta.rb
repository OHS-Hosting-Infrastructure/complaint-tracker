module Api
  class ErrorTta < Error
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

    def title
      @title ||= @body[:title] || default_title
    end
  end
end
