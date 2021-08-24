require "rails_helper"

RSpec.describe "complaints/show.html.erb", type: :view do
  let(:complaint) { Api::FakeData::Complaint.new.data }
  let(:issue_number) { complaint[:id] }
  let(:grantee_name) { complaint.dig :attributes, :grantee }
  let(:issue_text) { complaint.dig :attributes, :issue }

  before do
    assign(:complaint, complaint)
    render
  end

  it "displays the issue number in an h1" do
    expect(rendered).to match "<h1>Issue ##{issue_number}</h1>"
  end

  it "displays the grantee name" do
    expect(rendered).to match grantee_name
  end

  it "displays the issue text" do
    expect(rendered).to match issue_text
  end
end
