require "rails_helper"

RSpec.describe Api::FakeData::Review do
  let(:review) { Api::FakeData::Review.new(id: "1111") }

  describe "#data" do
    it "returns the data for a single review" do
      data = review.data

      expect(data[:id]).to be_a(String)
      expect(data[:type]).to eq "reviews"
      expect(data[:attributes]).to be_a(Hash)
      expect(data.dig(:attributes, :grantNumbers)).to be_a(Array)
      expect(data[:links]).to be_a(Hash)
    end

    it "data is the same upon multiple invocations" do
      data1 = review.data
      data2 = review.data
      expect(data1).to eq data2
    end
  end
end
