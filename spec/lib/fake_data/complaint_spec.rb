require "rails_helper"

RSpec.describe FakeData::Complaint do
  let(:complaint) { FakeData::Complaint.new }

  describe "#data" do
    it "returns the data for a single complaint" do
      data = complaint.data

      expect(data[:id]).to_not be_nil
      expect(data[:id]).to be_a(String)
      expect(data[:attributes]).to be_a(Hash)
      expect(data.dig(:relationships, :grantAward, :meta, :id)).to be_a(String)
      expect(data[:links]).to be_a(Hash)
    end
  end

  describe "datetime" do
    it "returns a string formatted as ISO-8601 UTC datetime" do
      datetime = complaint.datetime

      expect(datetime).to be_a(String)
      expect(Time.iso8601(datetime)).to be_a(Time)
    end
  end

  describe "identifier" do
    it "returns a string" do
      expect(complaint.identifier).to be_a(String)
    end
  end
end
