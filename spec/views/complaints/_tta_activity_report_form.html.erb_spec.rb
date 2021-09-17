require "rails_helper"

RSpec.describe "complaints/_tta_activity_report_form.html.erb", type: :view do
  let(:complaint) { Complaint.new(Api::FakeData::Complaint.new.data) }

  before do
    render partial: "complaints/tta_activity_report_form", locals: {complaint: complaint}
  end

  it "is a form" do
    expect(rendered).to match "<form class=\"usa-search display-flex\" action=\"/issue_tta_reports\" accept-charset=\"UTF-8\" method=\"post\">"
  end

  it "has a hidden field with the issue id" do
    expect(rendered).to match "<input type=\"hidden\" name=\"issue_id\" id=\"issue_id\" value=\"#{complaint.id}\" />"
  end
end
