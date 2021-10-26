require "rails_helper"

RSpec.describe "rendering complaints list" do
  let(:complaint) { Api::FakeData::Complaint.new.data }

  it "displays a complaint card" do
    complaint[:id] = "12345"

    render partial: "complaints/complaints_list_detail", locals: {complaint: complaint}
    complaint_header = "<h2> Complaint #<%= complaint[:id] %></h2>"
    expect(rendered.squish).to match complaint_header
  end
end
