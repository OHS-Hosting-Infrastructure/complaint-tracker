require "rails_helper"

RSpec.describe FakeData::ApiResponse do
  describe "generate_hses_issues_response" do
    it "returns a JSON-API object with 25 complaints" do
      res = FakeData::ApiResponse.generate_hses_issues_response

      expect(res[:data].length).to eq(25)
    end
  end

  describe "hses_issues_response" do
    it "returns JSON-API object with persistent complaints" do
      res1 = FakeData::ApiResponse.hses_issues_response[:data].first
      res2 = FakeData::ApiResponse.hses_issues_response[:data].first

      expect(res1).to eq(res2)
    end
  end

  describe "hses_issue_response" do
    it "returns the expected issue as a json api response" do
      expected = FakeData::ApiResponse.hses_issues_response[:data].second
      actual = FakeData::ApiResponse.hses_issue_response(expected[:id])[:data]

      expect(actual).to eq(expected)
    end
  end

  describe "generate_hses_issue_response" do
    it "returns a JSON-API object with a single complaint" do
      res = FakeData::ApiResponse.generate_hses_issue_response

      expect(res[:data].keys.length).to be > 0
    end
  end

  describe "jsonapi_list_wrapper" do
    it "returns an object with JSON-API top level JSON API" do
      wrapper = FakeData::ApiResponse.jsonapi_list_wrapper

      expect(wrapper[:meta]).to be_a(Hash)
      expect(wrapper[:data]).to be_a(Array)
      expect(wrapper[:links]).to be_a(Hash)
      expect(wrapper[:included]).to be_a(Array)
    end
  end

  describe "jsonapi_details_wrapper" do
    it "returns an object with JSON-API top level format" do
      wrapper = FakeData::ApiResponse.jsonapi_details_wrapper

      expect(wrapper[:data]).to be_a(Hash)
      expect(wrapper[:included]).to be_a(Array)
    end
  end
end
