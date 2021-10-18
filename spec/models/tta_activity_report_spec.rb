require "rails_helper"

RSpec.describe TtaActivityReport, type: :model do
  let(:access_token) { HsesAccessToken.new }
  let(:display_id) { "R14-AR-200" }

  subject do
    # models will retrieve the tta_report_id from FakeData based on the display ID
    described_class.new display_id, access_token
  end

  describe "validations" do
    it "is valid" do
      expect(subject).to be_valid
    end

    context "unauthorized report" do
      let(:display_id) { "R14-AR-403" }

      it "is invalid" do
        expect(subject).to_not be_valid
      end
    end
  end

  describe "#ttahub_url" do
    it "returns the URL to view the report in TTA Hub" do
      expect(subject.ttahub_url).to match %r{https://ttahub.ohs.acf.hhs.gov/activity-reports/view/\d+}
    end

    it "raises an error when there is an error with the api" do
      # This display ID will trigger a 403 error in the TTA Hub API
      subject.display_id = "R14-AR-403"
      expect { subject.ttahub_url }.to raise_error(Api::Error)
    end
  end

  describe "#topics" do
    it "returns an array of topics" do
      expect(subject.topics).to be_a(Array)
    end

    it "raises an error when there is an error with the api" do
      # This display ID will trigger a 403 error in the TTA Hub API
      subject.display_id = "R14-AR-403"
      expect { subject.topics }.to raise_error(Api::Error)
    end
  end

  describe "#author_name" do
    it "returns the author's name" do
      expect(subject.author_name).to be_a(String)
    end

    it "returns nil when the data field is missing" do
      # This display ID will trigger a successful response but without the author field
      subject.display_id = "R14-AR-missing-author"
      expect(subject.author_name).to be nil
    end

    it "raises an error when there is an error with the api" do
      # This display ID will trigger a 403 error in the TTA Hub API
      subject.display_id = "R14-AR-403"
      expect { subject.author_name }.to raise_error(Api::Error)
    end
  end

  describe "#api_error_message" do
    context "report is valid" do
      it "returns nil" do
        expect(subject.api_error_message).to be nil
      end
    end

    context "report is invalid" do
      let(:display_id) { "R14-AR-403" }

      it "returns an appropriate error message" do
        expect(subject.api_error_message).to eq "You do not have permission to access this activity report."
      end
    end
  end
end
