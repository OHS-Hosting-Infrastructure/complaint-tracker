require "rails_helper"

RSpec.describe "rendering no complaints alert" do
  it "has no table" do
    @complaints = []
    render partial: "complaints/no_complaints_alert"

    expect(rendered).to_not match '<table class="usa-table">'
  end

  it "has an alert heading" do
    @complaints = []
    render partial: "complaints/no_complaints_alert"

    expect(rendered).to match '<h3 class="usa-alert__heading">No issues found</h3>'
  end
end
