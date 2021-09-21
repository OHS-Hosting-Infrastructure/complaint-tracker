require "rails_helper"

RSpec.describe "complaints/_tta_report_list.html.erb", type: :view do
  let(:issue_tta) do
    IssueTtaReport.new(
      issue_id: "12345",
      tta_report_display_id: "RO2-AR-10992",
      tta_report_id: "12345"
    )
  end

  before do
    render partial: "complaints/tta_report_list", locals: {tta_reports: [issue_tta]}
  end

  it "has the TTA Activity label" do
    expect(rendered).to match "TTA Activity:"
  end

  it "has a div with the TTA display id" do
    expect(rendered).to match issue_tta.tta_report_display_id
  end
end
