require "rails_helper"

RSpec.describe Timeline::TtaEvent do
  let(:date) { 1.day.ago.strftime("%F") }
  let(:display_id) { "Test-Display-Name" }
  # just setting the start_date manually because we aren't triggering the before_validation callback
  let(:event_param) { IssueTtaReport.new tta_report_display_id: display_id, start_date: date }
  let(:tta_activity_report) { event_param.tta_activity_report }
  subject { Timeline::TtaEvent.new(event_param) }

  describe "#init" do
    it "assigns attr_readers inherited from Timeline::Event" do
      expect(subject.name).to eq display_id
      expect(subject.date).to eq Date.parse(date)
    end
  end

  describe "#hub_link" do
    it "returns a link that opens in a new tab" do
      expect(subject.hub_link).to match /\A<a .*>#{display_id}<\/a>\z/
      expect(subject.hub_link).to include 'target="_blank"'
    end

    context "authorization error loading TTA API" do
      # display id will trigger a 403 error
      let(:event_param) { IssueTtaReport.new tta_report_display_id: "R01-AR-403" }

      it "returns just the display ID with no link" do
        expect(subject.hub_link).to eq "R01-AR-403"
      end
    end
  end

  describe "#topics_string" do
    it "joins the issue topics together with commas" do
      tta_activity_report.topics.each do |topic|
        expect(subject.topics_string).to include topic
      end
    end
  end

  describe "#timeline_partial" do
    it "returns the tta event timeline partial" do
      expect(subject.timeline_partial).to eq "tta_timeline_event"
    end
  end

  describe "#formatted_date" do
    it "returns the date formatted '%m/%d/%Y'" do
      expect(subject.formatted_date).to eq Date.parse(date).strftime("%m/%d/%Y")
    end
  end
end
