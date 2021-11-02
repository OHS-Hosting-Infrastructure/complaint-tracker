require "rails_helper"

RSpec.describe "grantees/show", type: :view do
  let(:id) { "fake-grantee-789" }
  let(:grantee) { Grantee.new(id) }
  let(:complaint) { grantee.complaints.first }

  before do
    assign(:grantee, grantee)
    render
  end

  it "displays the grantee name in an h1" do
    expect(rendered).to match "<h1>#{grantee.name}</h1>"
  end

  it "displays the grantee number and region in an h2" do
    expect(rendered).to match "<h2>Grantee ##{grantee.id}, Region #{grantee.region}</h2>"
  end

  it "displays the grant numbers in an h3" do
    expect(rendered).to match "<h3>Active grants: #{grantee.formatted_grant_ids}</h3>"
  end

  describe "summary card" do
    it "displays the summary card header" do
      expect(rendered).to match "<h2>Summary</h2>"
    end

    it "displays a link to the HSES page" do
      link_element = "<a href=\"#{grantee.hses_link}\""
      expect(rendered).to match link_element
    end
  end

  it "displays the open issues card" do
    expect(rendered).to match "<h2>Open Issues</h2>"
  end

  describe "complaints list" do
    it "displays the list" do
      expect(rendered).to match '<ul class=\"usa-list usa-list--unstyled\">'
    end

    it "displays the complaint list item" do
      complaint_header = "<h2>Complaint ##{complaint.id}</h2>"
      expect(rendered).to match complaint_header
    end
  end
end
