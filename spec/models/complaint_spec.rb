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

  describe "#creation_date" do
    context "when provided string with valid date" do
      it "returns date object" do
        expect(subject.creation_date).to be_a Date
      end
    end

    context "when no date provided" do
      before { subject.attributes[:creationDate] = nil }
      it "returns nil" do
        expect(subject.creation_date).to be_nil
      end
    end
  end

  describe "#formatted_creation_date" do
    it "returns mm/dd/yyyy" do
      expect(subject.formatted_creation_date).to match(/\d{2}\/\d{2}\/\d{4}/)
    end
  end

  describe "#formatted_issue_last_updated" do
    it "returns mm/dd/yyyy" do
      expect(subject.formatted_creation_date).to match(/\d{2}\/\d{2}\/\d{4}/)
    end
  end

  # TODO: test for missing attribute
  describe "#grantee" do
    it "delegates to the attributes" do
      expect(subject.grantee).to eq hses_complaint[:attributes][:grantee]
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

  describe "#has_monitoring_review?" do
    context "has associated review" do
      it "returns true" do
        allow(IssueMonitoringReview).to receive(:where).and_return([1])
        expect(subject.has_monitoring_review?).to be true
      end
    end

    context "does not have associated review" do
      it "returns false" do
        expect(subject.has_monitoring_review?).to be false
      end
    end
  end

  describe "#has_tta_report?" do
    context "has associated report" do
      it "returns true" do
        allow(IssueTtaReport).to receive(:where).and_return([1])
        expect(subject.has_tta_report?).to be true
      end
    end

    context "does not have associated report" do
      it "returns false" do
        expect(subject.has_tta_report?).to be false
      end
    end
  end

  describe "#new?" do
    context "complaint is less than a week old" do
      context "an open complaint" do
        before { subject.attributes[:status][:id] = 0 }

        it "is new" do
          expect(subject.new?).to be true
        end
      end

      context "a complaint that is not open" do
        before { subject.attributes[:status][:id] = 5 }

        it "is not new" do
          expect(subject.new?).to be false
        end
      end
    end

    context "complaint is more than a week old" do
      before { subject.attributes[:creationDate] = 8.days.before.to_date.iso8601 }
      before { subject.attributes[:status][:id] = 0 }

      context "an open complaint" do
        it "is not new" do
          expect(subject.new?).to be false
        end
      end

      context "a complaint that is not open" do
        before { subject.attributes[:status][:id] = 5 }

        it "is not new" do
          expect(subject.new?).to be false
        end
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
      before { subject.attributes[:dueDate] = Date.current.to_date.iso8601 }

      it "returns the correct html string" do
        strftime = Date.current.strftime("%m/%d/%Y")
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

  describe "#status" do
    context "a complaint that is less than a week old and open" do
      before { subject.attributes[:creationDate] = 5.days.before.to_date.iso8601 }
      before { subject.attributes[:status][:id] = 0 }

      it "returns 'New'" do
        expect(subject.status).to eq "New"
      end
    end

    context "a complaint that is more than a week old and open" do
      before { subject.attributes[:creationDate] = 8.days.before.to_date.iso8601 }
      before { subject.attributes[:status][:id] = 0 }

      it "returns 'In Progress'" do
        expect(subject.status).to eq "In Progress"
      end
    end

    context "a complaint that is not open" do
      before { subject.attributes[:status][:id] = 1 }

      it "returns 'Closed'" do
        expect(subject.status).to eq "Closed"
      end
    end

    context "a complaint that is recommended for closure" do
      before { subject.attributes[:status][:id] = 2 }

      it "returns 'Rec. Closure'" do
        expect(subject.status).to eq "Rec. Closure"
      end
    end
  end

  # TODO: test for missing attribute
  describe "#summary" do
    it "delegates to the attributes" do
      expect(subject.summary).to eq hses_complaint[:attributes][:summary]
    end
  end
end
