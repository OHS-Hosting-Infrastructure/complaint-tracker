require "rails_helper"

RSpec.describe "rendering complaints table" do
  describe "with no complaints" do
    it "has no table" do
      @complaints = []
      render partial: "complaints/complaints_data"

      expect(rendered).to match '<h3 class="usa-alert__heading">No issues found</h3>'
      expect(rendered).to_not match '<table class="usa-table">'
    end
  end

  describe "with one or more complaints" do
    let(:complaint) { FakeData::Complaint.new.data }

    it "has a table to display complaints" do
      @complaints = [complaint]
      render partial: "complaints/complaints_data"

      expect(rendered).to match '<table class="usa-table">'
    end
  end
end
