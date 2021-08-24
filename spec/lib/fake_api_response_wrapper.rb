require "rails_helper"
require "fake_api_response_wrapper"

RSpec.describe FakeApiResponseWrapper do
  let(:test_class) { Class.new { extend FakeApiResponseWrapper } }
  describe "list_wrapper" do
    it "returns an object with JSON-API top level JSON API" do
      wrapper = test_class.list_wrapper

      expect(wrapper[:meta]).to be_a(Hash)
      expect(wrapper[:data]).to be_a(Array)
      expect(wrapper[:links]).to be_a(Hash)
      expect(wrapper[:included]).to be_a(Array)
    end
  end

  describe "jsonapi_details_wrapper" do
    it "returns an object with JSON-API top level format" do
      wrapper = test_class.details_wrapper

      expect(wrapper[:data]).to be_a(Hash)
      expect(wrapper[:included]).to be_a(Array)
    end
  end
end
