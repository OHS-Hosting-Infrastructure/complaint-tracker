require "fake_api_response_wrapper"

class FakeIssues
  include Singleton
  include FakeApiResponseWrapper

  attr_accessor :complaints

  def json
    @json ||= list_wrapper.merge(
      data: 25.times.map { |index|
        Api::FakeData::Complaint.new.data.tap do |complaint|
          complaint[:id] = (1500 + index).to_s
        end
      }
    )
  end
end
