require "rails_helper"

RSpec.describe FakeData::Complaints do
  describe "jsonapi_wrapper" do
    it "returns an object with JSON-API top level JSON API" do
      wrapper = FakeData::Complaints.jsonapi_wrapper

      expect(wrapper[:meta]).to be_a(Hash)
      expect(wrapper[:data]).to be_a(Array)
      expect(wrapper[:links]).to be_a(Hash)
    end
  end

  describe "complaint_data" do
    it "returns a single complaint object" do
      complaint = FakeData::Complaints.data

      expect(complaint[:id]).to_not be_nil
      expect(complaint[:attributes]).to be_a(Hash)
      expect(complaint.dig(:relationships, :grantAward, :meta, :id)).to be_a(String)
      expect(complaint[:links]).to be_a(Hash)
    end
  end

  describe "generate_response" do
    it "returns a JSON-API object with 25 complaints" do
      res = FakeData::Complaints.generate_response

      expect(res[:data].length).to eq(25)
    end
  end
end
