require "rails_helper"
require "fake_issues"

RSpec.describe Api::FakeData::Hses do
  describe "Issue" do
    let(:complaint) { FakeIssues.instance.data[4] }

    describe "#request" do
      let(:issue_endpoint) { Api::FakeData::Hses::Issue.new(id: complaint[:id]) }
      it "returns the correct complaint" do
        expect(issue_endpoint.request.data).to eq complaint
      end

      it "wraps the complaint in a detail wrapper" do
        expect(issue_endpoint.request.body.keys).to eq ["data"]
      end
    end
  end

  describe "Issues" do
    describe "#request" do
      let(:issues_endpoint) { Api::FakeData::Hses::Issues.new(user: {"uid" => "test"}) }
      it "returns the correct complaint" do
        expect(issues_endpoint.request.data).to eq FakeIssues.instance.data
      end

      it "wraps the complaint in a detail wrapper" do
        expect(issues_endpoint.request.body.keys).to eq %w[meta data]
      end
    end
  end

  describe "Grantee" do
    let(:grantee_id) { "fake-grantee-1234" }

    describe "#request" do
      let(:grantee_endpoint) { Api::FakeData::Hses::Grantee.new(id: grantee_id) }

      it "returns a grantee with the correct id" do
        expect(grantee_endpoint.request.data["id"]).to eq grantee_id
      end

      it "wraps the complaint in a detail wrapper" do
        expect(grantee_endpoint.request.body.keys).to eq ["data"]
      end
    end
  end
end
