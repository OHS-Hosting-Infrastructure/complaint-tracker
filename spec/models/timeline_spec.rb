require "rails_helper"

RSpec.describe Timeline do
  let(:display_id) { "First-Display-ID" }
  let(:display_id_2) { "Second-Display-ID" }
  let(:tta_activity_report) { Api::FakeData::ActivityReport.new(display_id: display_id).data }
  let(:tta_activity_report_2) { Api::FakeData::ActivityReport.new(display_id: display_id_2).data }

  describe "#events" do
    describe "no complaint attributes" do
      describe "no TTA activity reports" do
        it "returns an empty array" do
          timeline = Timeline.new({}, [])
          expect(timeline.events).to eq []
        end
      end

      describe "with a TTA activity report" do
        it "returns an array with only a TTA Event" do
          timeline = Timeline.new({}, [tta_activity_report])

          expect(timeline.events.count).to be 1
          expect(timeline.events.first).to be_a Timeline::TtaEvent
          expect(timeline.events.first.name).to eql display_id
        end
      end

      describe "multiple TTA activity reports" do
        it "returns an array with TTA events in desc order" do
          timeline = Timeline.new({}, [tta_activity_report, tta_activity_report_2])
          first_report = timeline.events.first
          second_report = timeline.events.last

          expect(timeline.events.count).to be 2
          expect(first_report.date > second_report.date).to be true
        end
      end
    end

    describe "no needed complaint attributes" do
      let(:events) do
        {
          agencyId: 345,
          otherRandomAttribute: "test attribute"
        }
      end

      describe "no TTA activity reports" do
        it "returns an empty array" do
          timeline = Timeline.new(events, [])
          expect(timeline.events).to eq []
        end
      end

      describe "with a TTA activity report" do
        it "returns an array with only the TTA event" do
          timeline = Timeline.new(events, [tta_activity_report])

          expect(timeline.events.count).to be 1
          expect(timeline.events.first).to be_a Timeline::TtaEvent
          expect(timeline.events.first.name).to eql display_id
        end
      end

      describe "multiple TTA activity reports" do
        it "returns an array with TTA events in desc order" do
          timeline = Timeline.new(events, [tta_activity_report, tta_activity_report_2])
          first_report = timeline.events.first
          second_report = timeline.events.last

          expect(timeline.events.count).to be 2
          expect(first_report.date > second_report.date).to be true
        end
      end
    end

    describe "with needed complaint events" do
      let(:issue_last_updated) { 1.day.ago.strftime("%F") }
      let(:creation_date) { 6.days.ago.strftime("%F") }
      let(:initial_contact_date) { 1.week.ago.strftime("%F") }

      let(:events) do
        {
          issueLastUpdated: issue_last_updated,
          creationDate: creation_date,
          initialContactDate: initial_contact_date,
          otherRandomAttribute: "test attribute"
        }
      end

      describe "with no TTA activity report" do
        it "returns an array with just ComplaintEvent objects" do
          timeline = Timeline.new(events, [])

          expect(timeline.events.count).to be 3
          timeline.events.each do |event|
            expect(event).to be_a Timeline::ComplaintEvent
          end
        end

        it "returns an array with objects in descending order" do
          timeline = Timeline.new(events, [])
          expect(timeline.events.first.date).to eq Date.parse(events[:issueLastUpdated])
          expect(timeline.events.second.date).to eq Date.parse(events[:creationDate])
          expect(timeline.events.last.date).to eq Date.parse(events[:initialContactDate])
        end
      end

      describe "with a TTA activity report" do
        it "returns an array with all the necessary events" do
          timeline = Timeline.new(events, [tta_activity_report])

          expect(timeline.events.count).to be 4
        end
      end
    end
  end

  describe "ComplaintEvent" do
    let(:date) { 1.day.ago.strftime("%F") }
    let(:name) { "reopenedDate" }
    let(:event_param) { [name, date] }

    describe "#init" do
      it "assigns attr_readers" do
        event = Timeline::ComplaintEvent.new(event_param)
        expect(event.name).to eq name
        expect(event.date).to eq Date.parse(date)
      end
    end

    describe "#label" do
      it "returns the correct label" do
        event = Timeline::ComplaintEvent.new(event_param)
        expect(event.label).to eq "Reopened"
      end

      it "falls back to Updated if there is no correct label" do
        event = Timeline::ComplaintEvent.new(["surpriseEvent", date])
        expect(event.label).to eq "Updated"
      end
    end

    describe "#formatted_date" do
      it "returns the date formatted '%m/%d/%Y'" do
        event = Timeline::ComplaintEvent.new(event_param)
        expect(event.formatted_date).to eq Date.parse(date).strftime("%m/%d/%Y")
      end
    end
  end

  describe "TtaEvent" do
    let(:date) { 1.day.ago.strftime("%F") }
    let(:display_id) { "Test-Display-Name" }
    let(:event_param) do
      {
        attributes: {
          displayId: display_id,
          startDate: date
        }
      }
    end

    describe "#init" do
      it "assigns attr_readers" do
        event = Timeline::TtaEvent.new(event_param)
        expect(event.name).to eq display_id
        expect(event.date).to eq Date.parse(date)
      end
    end

    describe "#label" do
      it "returns the correct label" do
        event = Timeline::TtaEvent.new(event_param)
        expect(event.label).to eq "TTA Activity: #{display_id}"
      end
    end

    describe "#formatted_date" do
      it "returns the date formatted '%m/%d/%Y'" do
        event = Timeline::TtaEvent.new(event_param)
        expect(event.formatted_date).to eq Date.parse(date).strftime("%m/%d/%Y")
      end
    end
  end
end
