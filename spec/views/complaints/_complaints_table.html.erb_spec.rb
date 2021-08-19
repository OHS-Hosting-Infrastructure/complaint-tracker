require "rails_helper"

RSpec.describe "rendering complaints table" do
  let(:complaint) { FakeData::Complaint.new.data }
  it "has a table to display complaints" do
    @complaints = [complaint]

    render partial: "complaints/complaints_table"

    expect(rendered).to match '<table class="usa-table">'
  end
end
