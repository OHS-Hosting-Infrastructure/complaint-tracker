require "rails_helper"

RSpec.describe Timeline::MonitoringEvent do
  let(:date) { 1.day.ago.strftime("%F") }
  let(:review_id) { "Test-Review-ID" }
  let(:issue_id) { "Test-Issue-ID" }
  # just setting the start_date manually because we aren't triggering the before_validation callback
  let(:event_param) { IssueMonitoringReview.new review_id: review_id, issue_id: issue_id, start_date: date }
  subject { Timeline::MonitoringEvent.new(event_param) }

  describe "#init" do
    it "assigns attr_readers inherited from Timeline::Event" do
      expect(subject.name).to eq review_id
      expect(subject.date).to eq Date.parse(date)
    end
  end

  describe "#review_link" do
    it "returns a link that opens in a new tab" do
      expect(subject.review_link).to match /\A<a .*>#{review_id}<\/a>\z/
      expect(subject.review_link).to include 'target="_blank"'
    end

    context "authorization error loading Monitoring API" do
      xit "returns just the review ID with no link"
    end
  end

  describe "#review_type" do
    it "returns the review type" do
      expect(subject.review_type).to be_a(String)
    end
  end

  describe "#status" do
    it "returns the review status" do
      expect(subject.status).to be_a(String)
    end
  end

  describe "#timeline_partial" do
    it "returns the monitoring event timeline partial" do
      expect(subject.timeline_partial).to eq "monitoring_timeline_event"
    end
  end

  describe "#formatted_date" do
    it "returns the date formatted '%m/%d/%Y'" do
      expect(subject.formatted_date).to eq Date.parse(date).strftime("%m/%d/%Y")
    end
  end
end
