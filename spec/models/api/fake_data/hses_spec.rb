require "rails_helper"
require "fake_issues"

RSpec.describe Api::FakeData::Hses do
  describe "Issue" do
    let(:complaint) { FakeIssues.instance.json[:data][4] }

    describe "#request" do
      let(:issue_endpoint) { Api::FakeData::Hses::Issue.new(id: complaint[:id]) }
      it "returns the correct complaint" do
        expect(issue_endpoint.request[:data]).to eq complaint
      end

      it "wraps the complaint in a detail wrapper" do
        expect(issue_endpoint.request.keys).to eq [:data]
      end
    end
  end

  describe "Issues" do
    describe "#request" do
      let(:issues_endpoint) { Api::FakeData::Hses::Issues.new }
      it "returns the correct complaint" do
        expect(issues_endpoint.request).to eq FakeIssues.instance.json
      end

      it "wraps the complaint in a detail wrapper" do
        expect(issues_endpoint.request.keys).to eq [:meta, :data]
      end
    end
  end
end
