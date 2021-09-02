require "rails_helper"

RSpec.describe Complaint do
  let(:hses_complaint) { Api::FakeData::Complaint.new.data }
  subject { described_class.new hses_complaint }

  let(:issue_last_updated) { 1.day.ago.iso8601 }
  let(:creation_date) { 6.days.ago.iso8601 }
  let(:initial_contact_date) { 1.week.ago.iso8601 }

  before do
    hses_complaint[:attributes].merge!({
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
end
