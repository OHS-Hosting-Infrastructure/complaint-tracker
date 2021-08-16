require "rails_helper"

RSpec.describe FakeData::ApiResponse do
  describe "generate_response" do
    it "returns a JSON-API object with 25 complaints" do
      res = FakeData::ApiResponse.generate_hses_issues_response

      expect(res[:data].length).to eq(25)
    end
  end

  describe "jsonapi_wrapper" do
    it "returns an object with JSON-API top level JSON API" do
      wrapper = FakeData::ApiResponse.jsonapi_wrapper

      expect(wrapper[:meta]).to be_a(Hash)
      expect(wrapper[:data]).to be_a(Array)
      expect(wrapper[:links]).to be_a(Hash)
    end
  end
end
