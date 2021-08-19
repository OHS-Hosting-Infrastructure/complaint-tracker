require "rails_helper"

RSpec.describe "rendering flash_messages" do
  it "matches a notice message" do
    flash[:notice] = "Testing flash notice"
    render partial: "layouts/flash_messages"

    expect(rendered).to match "Testing flash notice"
    expect(rendered).to match "usa-alert--success"
  end

  it "matches an error message" do
    flash[:alert] = "Testing error notice"
    render partial: "layouts/flash_messages"

    expect(rendered).to match "Testing error notice"
    expect(rendered).to match "usa-alert--error"
  end

  it "matches a notice and error message" do
    flash[:notice] = "Testing flash notice"
    flash[:alert] = "Testing error notice"
    render partial: "layouts/flash_messages"

    expect(rendered).to match "Testing flash notice"
    expect(rendered).to match "Testing error notice"
  end

  it "displays nothing if there are no messages" do
    render partial: "layouts/flash_messages"

    expect(rendered).to eq ""
  end
end
