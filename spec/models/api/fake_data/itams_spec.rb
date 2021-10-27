require "rails_helper"

RSpec.describe Api::FakeData::Itams do
  describe "Review" do
    subject { Api::FakeData::Itams::Review.new(id: id) }

    describe "#request" do
      let(:id) { "1234" }

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
