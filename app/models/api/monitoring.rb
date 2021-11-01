# TODO remove fake api business once this is hooked up
require "fake_api_response_wrapper"

module Api::Monitoring
  include FakeApiResponseWrapper
  attr_accessor :id

  def initialize(id:, access_token:)
    @id = id
  end

  def request
    details_response(
      Api::FakeData::MonitoringReview.new(id: id).data
    )
  end
end
