require "rails_helper"

RSpec.describe Complaint do
  let(:hses_complaint) { Api::FakeData::Complaint.new.data }
  subject { described_class.new hses_complaint }

  let(:due_date) { 1.week.from_now.to_date.iso8601 }
  let(:issue_last_updated) { 1.day.ago.iso8601 }
  let(:creation_date) { 6.days.ago.iso8601 }
  let(:initial_contact_date) { 1.week.ago.iso8601 }

  before do
    hses_complaint[:attributes].merge!({
      dueDate: due_date,
      issueLastUpdated: issue_last_updated,
      creationDate: creation_date,
      closedDate: nil,
      reopenedDate: nil,
      initialContactDate: initial_contact_date
    })
  end

  describe "initialize" do
    it "sets @id" do
      expect(subject.id).to eq hses_complaint[:id]
    end

    it "sets @attributes" do
      expect(subject.attributes).to eq hses_complaint[:attributes].with_indifferent_access
    end
  end

  describe "#grantee" do
    it "deletages to the attributes" do
      expect(subject.grantee).to eq hses_complaint[:attributes][:grantee]
    end
  end

  describe "#events" do
    let(:events) do
      [
        {
          name: "issueLastUpdated",
          date: Time.parse(issue_last_updated)
        },
        {
          name: "creationDate",
          date: Time.parse(creation_date)
        },
        {
          name: "initialContactDate",
          date: Time.parse(initial_contact_date)
        }
      ]
    end

    it "returns a sorted array of populated event dates" do
      expect(subject.events).to eq events
    end
  end

  describe "#due_date?" do
    context "due date is present" do
      it "returns true" do
        expect(subject.due_date?).to be true
      end
    end

    context "due date is blank" do
      before { subject.attributes[:dueDate] = nil }

      it "returns false" do
        expect(subject.due_date?).to be false
      end
    end
  end

  describe "#overdue?" do
    before { subject.attributes[:dueDate] = 1.day.ago.iso8601 }

    context "due date in past" do
      it "is overdue" do
        expect(subject).to be_overdue
      end
    end

    context "due date in future" do
      before { subject.attributes[:dueDate] = 1.month.from_now.to_date.iso8601 }

      it "is not overdue" do
        expect(subject).not_to be_overdue
      end
    end

    context "due date missing" do
      before { subject.attributes[:dueDate] = nil }

      it "is not overdue" do
        expect(subject).not_to be_overdue
      end
    end
  end

  describe "#due_soon?" do
    context "due date more than a week away" do
      before { subject.attributes[:dueDate] = 1.month.from_now.to_date.iso8601 }

      it "is not due soon" do
        expect(subject).not_to be_due_soon
      end
    end

    context "due date less than a week away" do
      before { subject.attributes[:dueDate] = 2.days.from_now.to_date.iso8601 }

      it "is due soon" do
        expect(subject).to be_due_soon
      end
    end
  end

  describe "relative_due_date_html" do
    context "due today" do
      before { subject.attributes[:dueDate] = Date.today.to_date.iso8601 }

      it "returns the correct html string" do
        strftime = Date.today.strftime("%m/%d/%Y")

        expect(subject.relative_due_date_html).to eq(
          "<span class=\"ct-timeline__due-soon\">Due today (#{strftime})</span>"
        )
      end
    end

    context "due in a single day" do
      before { subject.attributes[:dueDate] = 1.day.after.to_date.iso8601 }

      it "returns the correct html string" do
        strftime = 1.day.after.strftime("%m/%d/%Y")

        expect(subject.relative_due_date_html).to eq(
          "<span class=\"ct-timeline__due-soon\">Due in 1 day (#{strftime})</span>"
        )
      end
    end

    context "due in a week" do
      before { subject.attributes[:dueDate] = 7.days.after.to_date.iso8601 }

      it "returns the correct html string" do
        strftime = 7.days.after.strftime("%m/%d/%Y")

        expect(subject.relative_due_date_html).to eq(
          "<span class=\"ct-timeline__due-soon\">Due in 7 days (#{strftime})</span>"
        )
      end
    end

    context "due in a month" do
      before { subject.attributes[:dueDate] = 12.days.after.to_date.iso8601 }

      it "returns the correct html string" do
        strftime = 12.days.after.strftime("%m/%d/%Y")

        expect(subject.relative_due_date_html).to eq(
          "<span>Due in 12 days (#{strftime})</span>"
        )
      end
    end
  end

  describe "#summary" do
    it "delegates to the attributes" do
      expect(subject.summary).to eq hses_complaint[:attributes][:summary]
    end
  end
end
