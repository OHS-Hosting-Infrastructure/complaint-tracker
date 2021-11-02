require "rails_helper"

RSpec.describe "rendering monitoring event" do
  context "when status is not complete" do
    it "returns status and type" do
      event = OpenStruct.new(
        api_call_succeeded?: true,
        status: "In Progress",
        outcome: "Should not show up",
        review_type: "RAN"
      )

      render partial: "complaints/monitoring_timeline_event",
        locals: {event: event}
      expect(rendered).to include "<strong>Status:</strong> In Progress"
      expect(rendered).to include "<strong>Type:</strong> RAN"
      expect(rendered).to_not include "<strong>Outcome:</strong> Should not show up"
    end
  end

  context "when status is complete" do
    it "returns status, outcome, and type" do
      event = OpenStruct.new(
        api_call_succeeded?: true,
        status: "Complete",
        outcome: "Compliant",
        review_type: "RAN"
      )

      render partial: "complaints/monitoring_timeline_event",
        locals: {event: event}
      expect(rendered).to include "<strong>Status:</strong> Complete"
      expect(rendered).to include "<strong>Type:</strong> RAN"
      expect(rendered).to include "<strong>Outcome:</strong> Compliant"
    end
  end

  context "when error" do
    it "returns error message" do
      event = OpenStruct.new(
        api_call_succeeded?: false,
        api_error_message: "Something went wrong",
        status: "In Progress",
        outcome: "Deficient",
        review_type: "RAN"
      )

      render partial: "complaints/monitoring_timeline_event",
        locals: {event: event}
      expect(rendered).to include '<p class="usa-alert__text">Something went wrong</p>'
      expect(rendered).to_not include "<strong>Status:</strong> In Progress"
      expect(rendered).to_not include "<strong>Type:</strong> RAN"
      expect(rendered).to_not include "<strong>Outcome:</strong> Deficient"
    end
  end
end
