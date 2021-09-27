require "rails_helper"

RSpec.describe "complaints/show.html.erb", type: :view do
  let(:complaint) { Complaint.new(Api::FakeData::Complaint.new.data) }
  let(:issue_number) { complaint.id }
  let(:grantee_name) { complaint.grantee }
  let(:summary) { complaint.summary }

  describe "no TTA reports" do
    before do
      assign(:complaint, complaint)
      assign(:tta_reports, [])
      render
    end

    it "displays the issue number in an h1" do
      expect(rendered).to match "<h1>Issue ##{issue_number}</h1>"
    end

    it "displays the grantee name" do
      expect(rendered).to match CGI.escapeHTML(grantee_name)
    end

    it "displays the issue text" do
      expect(rendered).to match CGI.escapeHTML(summary)
    end
  end
end
