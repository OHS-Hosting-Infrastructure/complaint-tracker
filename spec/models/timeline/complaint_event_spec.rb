require "rails_helper"

RSpec.describe Timeline::ComplaintEvent do
  let(:date) { 1.day.ago.strftime("%F") }
  let(:name) { "reopenedDate" }
  let(:event_param) { [name, date] }
  subject { Timeline::ComplaintEvent.new(event_param) }

  describe "#init" do
    it "assigns attr_readers inherited from Timeline::Event" do
      expect(subject.name).to eq name
      expect(subject.date).to eq Date.parse(date)
    end
  end

  describe "#label" do
    it "returns the correct label" do
      expect(subject.label).to eq "Reopened"
    end

    context "with missing label" do
      let(:event_param) { ["surpriseEvent", date] }

      it "falls back to Updated" do
        expect(subject.label).to eq "Updated"
      end
    end
  end

  describe "#timeline_partial" do
    it "returns the generic content partial" do
      expect(subject.timeline_partial).to eq "generic_timeline_event"
    end
  end

  describe "#formatted_date" do
    it "returns the date formatted '%m/%d/%Y'" do
      expect(subject.formatted_date).to eq Date.parse(date).strftime("%m/%d/%Y")
    end
  end
end
