require "fake_api_response_wrapper"

class Api::FakeData::Itams
  class Review
    include FakeApiResponseWrapper
    attr_accessor :id

    def initialize(id:)
      @id = id
    end

    def request
      details_response(
        Api::FakeData::Review.new(id: id).data
      )
    end
  end
end
