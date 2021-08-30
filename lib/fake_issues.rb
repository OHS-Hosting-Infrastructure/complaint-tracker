require "fake_api_response_wrapper"

class FakeIssues
  include Singleton
  include FakeApiResponseWrapper

  attr_accessor :complaints

  def json
    @json ||= list_wrapper.merge(
      data: 25.times.map { |complaint| Api::FakeData::Complaint.new.data }
    )
  end
end
