require "rails_helper"

RSpec.describe FakeData::Complaints do
  describe "complaint_data" do
    it "returns a single complaint object" do
      complaint = FakeData::Complaints.data

      expect(complaint[:id]).to_not be_nil
      expect(complaint[:attributes]).to be_a(Hash)
      expect(complaint.dig(:relationships, :grantAward, :meta, :id)).to be_a(String)
      expect(complaint[:links]).to be_a(Hash)
    end
  end

  describe "datetime" do
    it "returns a string formatted as ISO-8601 UTC datetime" do
      dt = FakeData::Complaints.datetime
      expect(dt).to be_a(String)
      begin
        expect(Time.iso8601(dt)).to be_a(Time)
      rescue
        expect(false).to be_truthy
      end
    end
  end

  describe "identifier" do
    it "returns a string of numbers" do
      id = FakeData::Complaints.identifier
      expect(id).to be_a(String)
      expect(id.to_i.to_s).to eq(id)
    end
  end

  describe "generate_response" do
    it "returns a JSON-API object with 25 complaints" do
      res = FakeData::Complaints.generate_response

      expect(res[:data].length).to eq(25)
    end
  end

  describe "jsonapi_wrapper" do
    it "returns an object with JSON-API top level JSON API" do
      wrapper = FakeData::Complaints.jsonapi_wrapper

      expect(wrapper[:meta]).to be_a(Hash)
      expect(wrapper[:data]).to be_a(Array)
      expect(wrapper[:links]).to be_a(Hash)
    end
  end
end
