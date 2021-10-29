require "rails_helper"

RSpec.describe "complaints/_monitoring_create_review.html.erb", type: :view do
  let(:complaint) { Complaint.new(Api::FakeData::Complaint.new.data) }

  before do
    @complaint = complaint
    render partial: "complaints/monitoring_create_review"
  end

  it "is a form" do
    expect(rendered).to match "<form id=\"monitoring-review-form\" class=\"usa-search display-flex\" action=\"/issue_monitoring_reviews\" accept-charset=\"UTF-8\" data-remote=\"true\" method=\"post\">"
  end

  it "has a hidden field with the issue id" do
    expect(rendered).to match "<input type=\"hidden\" name=\"issue_id_monitoring\" id=\"issue_id_monitoring\" value=\"#{complaint.id}\" />"
  end
end
