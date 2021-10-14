module Api
  class Error < StandardError
    attr_reader :status, :title
    def initialize(response)
      @status = response.code
      @title = response.error_object[:title]
      super response.error_object[:details]
    end
  end
end
