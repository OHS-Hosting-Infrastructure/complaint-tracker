require "rails_helper"

RSpec.describe "rendering complaints table" do
  let(:complaint) { Api::FakeData::Complaint.new.data }

  it "has a table to display complaints" do
    @complaints = [complaint]
    @pagy = Pagy.new(count: 1)

    render partial: "complaints/complaints_table"

    expect(rendered).to match '<table class="usa-table">'
    expect(rendered).to match '<th scope=\"col\" role=\"columnheader\">HSES Issue #</th>\n'
  end

  it "has the ability to sort by creation date" do
    @complaints = [complaint]
    @pagy = Pagy.new(count: 1)

    render partial: "complaints/complaints_table"

    expect(rendered).to include <<-EOHTML
      <th
        data-sortable
        scope="col"
        role="columnheader"
        aria-sort="descending"
        data-next-sort="/complaints?page=1&amp;sort=creationDate"
      > Date Created </th>
    EOHTML
  end
end
