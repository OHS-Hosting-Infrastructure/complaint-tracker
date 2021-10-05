require "fake_api_response_wrapper"

class Api::FakeData::Tta
  class ActivityReport
    include FakeApiResponseWrapper
    attr_accessor :display_id

    def initialize(display_id:, access_token:)
      @display_id = display_id
    end

    def request
      details_wrapper.merge(
        data: Api::FakeData::ActivityReport.new(display_id: display_id).data
      )
    end
  end
end
