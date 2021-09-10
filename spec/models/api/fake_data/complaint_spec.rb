require "rails_helper"

RSpec.describe Api::FakeData::Complaint do
  let(:complaint) { Api::FakeData::Complaint.new }

  describe "#data" do
    it "returns the data for a single complaint" do
      data = complaint.data

      expect(data[:id]).to be_a(String)
      expect(data[:attributes]).to be_a(Hash)
      expect(data.dig(:attributes, :issueType, :label)).to be_a(String)
      expect(data[:links]).to be_a(Hash)
    end

    it "data is the same upon multiple invocations" do
      data1 = complaint.data
      data2 = complaint.data
      expect(data1).to eq data2
    end
  end
end
