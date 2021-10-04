require "rails_helper"

RSpec.describe "rendering complaints table" do
  let(:complaint) { Api::FakeData::Complaint.new.data }
  it "has a table to display complaints" do
    @complaints = [complaint]

    render partial: "complaints/complaints_table"

    expect(rendered).to match '<table class="usa-table" aria-describedby="#caption" >'
  end

  it "has the ability to sort by grantee" do
    @complaints = [complaint]

    render partial: "complaints/complaints_table"

    expect(rendered).to match '<th data-sortable scope="col" role="columnheader"> Grantee </th>'
  end
end
