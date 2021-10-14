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

  describe "#ttahub_url" do
    it "returns the URL to view the report in TTA Hub" do
      expect(subject.ttahub_url).to match %r{https://ttahub.ohs.acf.hhs.gov/activity-reports/view/\d+}
    end

    it "raises an error when there is an error with the api" do
      # This displa ID will trigger a 403 error in the TTA Hub API
      subject.tta_report_display_id = "R14-AR-403"
      expect { subject.ttahub_url }.to raise_error(Api::Error)
    end
  end

  describe "#api_call_succeeded?" do
    context "for an unauthorized report" do
      subject do
        # This displa ID will trigger a 403 error in the TTA Hub API
        described_class.new(
          issue_id: "ISSUE_ID",
          tta_report_display_id: "R14-AR-403"
        )
      end

      it "returns false" do
        expect(subject.api_call_succeeded?).to be false
      end
    end

    it "returns true" do
      expect(subject.api_call_succeeded?).to be true
    end
  end

  describe "#topics" do
    it "returns an array of topics" do
      expect(subject.topics).to be_a(Array)
    end

    it "raises an error when there is an error with the api" do
      # This displa ID will trigger a 403 error in the TTA Hub API
      subject.tta_report_display_id = "R14-AR-403"
      expect { subject.topics }.to raise_error(Api::Error)
    end
  end

  describe "#author_name" do
    it "returns the author's name" do
      expect(subject.author_name).to be_a(String)
    end

    it "raises an error when there is an error with the api" do
      # This displa ID will trigger a 403 error in the TTA Hub API
      subject.tta_report_display_id = "R14-AR-403"
      expect { subject.author_name }.to raise_error(Api::Error)
    end
  end
end
