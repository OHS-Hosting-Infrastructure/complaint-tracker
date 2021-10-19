require "rails_helper"

RSpec.describe Timeline do
  let(:display_id) { "First-Display-ID" }
  let(:display_id_2) { "Second-Display-ID" }
  let(:tta_activity_report) { IssueTtaReport.create tta_report_display_id: display_id, issue_id: "1" }
  let(:tta_activity_report_2) { IssueTtaReport.create tta_report_display_id: display_id_2, issue_id: "1" }

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
          expect(first_report.date >= second_report.date).to be true
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
          expect(first_report.date >= second_report.date).to be true
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
end
