require "rails_helper"

RSpec.describe "complaints/show.html.erb", type: :view do
  let(:complaint) { Complaint.new(Api::FakeData::Complaint.new.data) }
  let(:issue_number) { complaint.id }
  let(:agency_id) { complaint.agency_id }
  let(:grantee_name) { complaint.grantee }
  let(:summary) { complaint.summary }
  let(:timeline) { Timeline.new(complaint.attributes, [], []) }

  describe "no linked TTA reports nor monitoring reviews" do
    before do
      assign(:complaint, complaint)
      assign(:issue_tta_reports, [])
      assign(:issue_monitoring_reviews, [])
      assign(:timeline, timeline)
      render
    end

    it "displays the issue number in an h1" do
      expect(rendered).to match "<h1>HSES Issue ##{issue_number}</h1>"
    end

    it "displays the grantee name and link" do
      expect(rendered).to match "<strong><a class=\"usa-link\" href=\"/grantees/#{agency_id}\">#{CGI.escapeHTML(grantee_name)}</a>:</strong>"
    end

    it "displays the issue text" do
      expect(rendered).to match CGI.escapeHTML(summary)
    end
  end
end
