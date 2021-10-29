require "rails_helper"

RSpec.describe Api::FakeData::Monitoring do
  describe "Review" do
    subject { Api::FakeData::Monitoring::Review.new(id: id, access_token: access_token) }

    describe "#request" do
      let(:id) { "1234" }
      let(:access_token) { HsesAccessToken.new }

      it "returns a review with the correct id" do
        expect(subject.request.data[:id]).to eq id
      end

      it "wraps the review in a detail wrapper" do
        expect(subject.request.body).to match({
          data: {
            id: String,
            type: "reviews",
            attributes: Hash,
            links: Hash
          }
        })
      end
    end
  end
end
