require "rails_helper"

RSpec.describe "rendering complaints list" do
  let(:hses_complaint) { Api::FakeData::Complaint.new.data }
  let(:complaint) { Complaint.new(hses_complaint) }

  it "displays a complaint card" do
    render partial: "complaints/complaints_list_detail", locals: {complaint: complaint}
    complaint_header = "<h2>Complaint ##{complaint.id}</h2>"
    expect(rendered.squish).to match complaint_header
  end
end
