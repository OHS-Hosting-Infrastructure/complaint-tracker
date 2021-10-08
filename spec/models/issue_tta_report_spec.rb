require "rails_helper"

RSpec.describe IssueTtaReport, type: :model do
  describe "validations" do
    subject do
      described_class.new(
        issue_id: "ISSUE_ID",
        tta_report_display_id: "R14-AR-200"
      )
    end
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a issue id" do
      subject.issue_id = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without an activity report id" do
      subject.tta_report_display_id = "R14-AR-404"
      expect(subject).not_to be_valid
    end

    it "is not valid without a activity report display id" do
      subject.tta_report_display_id = nil
      expect(subject).not_to be_valid
    end

    it "is not valid if an identical report exists already" do
      IssueTtaReport.create(issue_id: "ISSUE_ID",
        tta_report_display_id: "R14-AR-200")
      expect(subject).not_to be_valid
    end
  end
end
