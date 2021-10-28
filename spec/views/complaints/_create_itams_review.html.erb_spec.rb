require "rails_helper"

RSpec.describe "complaints/_itams_create_review.html.erb", type: :view do
  let(:complaint) { Complaint.new(Api::FakeData::Complaint.new.data) }

  before do
    @complaint = complaint
    render partial: "complaints/itams_create_review"
  end

  it "is a form" do
    expect(rendered).to match "<form id=\"itams-review-form\" class=\"usa-search display-flex\" action=\"/issue_itams_reviews\" accept-charset=\"UTF-8\" data-remote=\"true\" method=\"post\">"
  end

  it "has a hidden field with the issue id" do
    expect(rendered).to match "<input type=\"hidden\" name=\"issue_id\" id=\"issue_id\" value=\"#{complaint.id}\" />"
  end
end
