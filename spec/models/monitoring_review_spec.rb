require "rails_helper"

RSpec.describe MonitoringReview, type: :model do
  let(:access_token) { HsesAccessToken.new }
  let(:id) { "1234" }

  subject do
    described_class.new id, access_token
  end

  describe "#itams_url" do
    it "returns the URL to view the report in IT-AMS" do
      expect(subject.itams_url).to eq "https://example.com/TODO"
    end
  end

    end
  end

  describe "#review_type" do
    it "returns a review type" do
      expect(FfakerWrapper::REVIEW_TYPE.include?(subject.review_type)).to be true
    end
  end

  describe "#start_date" do
    it "returns a start date" do
      expect(subject.start_date).to be_a(String)
    end
  end

  describe "#status" do
    it "returns a status" do
      expect(FfakerWrapper::REVIEW_STATUS.include?(subject.status)).to be true
    end
  end

  describe "#valid?" do
    context "with no errors" do
      it "is valid" do
        expect(subject.valid?).to be true
      end
    end

    context "with errors" do
      it "is not valid" do
        allow(subject).to receive(:review_data).and_return(OpenStruct.new(error: "Some error"))
        expect(subject.valid?).to be false
      end
    end
  end
end
