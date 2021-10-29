require "rails_helper"

RSpec.describe IssueMonitoringReview, type: :model do
  subject do
    described_class.new(
      issue_id: "ISSUE_ID",
      review_id: "IT-AMS-ID",
      start_date: 1.day.ago
    )
  end

  describe "validations" do
    it "is valid with all attributes set" do
      expect(subject).to be_valid
    end

    it "is not valid without an issue id" do
      subject.issue_id = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a review id" do
      subject.review_id = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a start date" do
      subject.start_date = nil
      allow(subject.monitoring_review).to receive(:valid?).and_return(false)
      expect(subject).not_to be_valid
    end

    it "is not valid if an identical join model already exists" do
      described_class.create(subject.attributes)
      expect(subject).not_to be_valid
    end
  end
end
