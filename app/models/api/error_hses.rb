module Api
  class ErrorHses < Error
    def details
      case @code
      when 403
        "You do not have permission to view these complaints. Please contact your administrator for assistance."
      else
        "We're currently unable to access complaint data. Please refresh the page, and if you still see a problem, check back again later."
      end
    end
  end
end
