require "rails_helper"

RSpec.describe IssueTtaReport, type: :model do
  subject do
    # models will retrieve the tta_report_id from FakeData based on the display ID
    described_class.new(
      issue_id: "ISSUE_ID",
      tta_report_display_id: "R14-AR-200"
    )
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a issue id" do
      subject.issue_id = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without an activity report id" do
      # This display ID cannot be found in the TTA Hub API, so will not get a tta_report_id
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

    it "saves the start date" do
      subject.valid? # trigger the before_validation callback
      expect(subject.start_date).to be_a(Date)
    end
  end
end
