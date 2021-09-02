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

  describe "#id" do
    it "delegates to the hses complaint" do
      expect(subject.id).to eq hses_complaint[:id]
    end
  end

  describe "#grantee" do
    it "deletages to the attributes" do
      expect(subject.grantee).to eq hses_complaint[:attributes][:grantee]
    end
  end

  describe "#other_type" do
    it "delegates with camel casing" do
      expect(subject.other_type).to eq hses_complaint[:attributes][:otherType]
    end
  end

  describe "#events" do
    it "returns a sorted array of populated event dates" do
      expect(subject.events).to eq [
        ["issueLastUpdated", Time.parse(issue_last_updated)],
        ["creationDate", Time.parse(creation_date)],
        ["initialContactDate", Time.parse(initial_contact_date)]
      ]
    end
  end

  describe "#due_date?" do
    context "due date is present" do
      it "returns true" do
        expect(subject.due_date?).to be true
      end
    end

    context "due date is blank" do
      let(:due_date) { "" }

      it "return false" do
        expect(subject.due_date?).to be false
      end
    end
  end

  describe "due_date" do
    it "returns a time object" do
      expect(subject.due_date).to be_kind_of(Date)
    end
  end

  describe "#overdue?" do
    context "due date in past" do
      let(:due_date) { 1.day.ago.to_date.iso8601 }
      it "is overdue" do
        expect(subject).to be_overdue
      end
    end

    context "due date in future" do
      it "is not overdue" do
        expect(subject).not_to be_overdue
      end
    end

    context "due date missing" do
      let(:due_date) { "" }
      it "is not overdue" do
        expect(subject).not_to be_overdue
      end
    end
  end

  describe "#due_soon?" do
    context "due date more than a week away" do
      let(:due_date) { 1.month.from_now.to_date.iso8601 }
      it "is not due soon" do
        expect(subject).not_to be_due_soon
      end
    end

    context "due date less than a week away" do
      let(:due_date) { 2.days.from_now.to_date.iso8601 }
      it "is due soon" do
        expect(subject).to be_due_soon
      end
    end
  end
end
