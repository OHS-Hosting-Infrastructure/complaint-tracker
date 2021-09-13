require "rails_helper"

RSpec.describe ComplaintsHelper, type: :helper do
  describe "#status" do
    describe "a complaint that is less than a week old" do
      let(:complaint) { {status: {id: 0}, creationDate: 1.day.ago} }

      describe "an open complaint" do
        it "returns 'New' as the formatted status" do
          expect(status(complaint)).to eq "New"
        end
      end

      describe "a complaint that is not open" do
        it "returns the formatted status of the complaint's status " do
          complaint[:status] = {id: 3}
          expect(status(complaint)).to eq ComplaintsHelper::FORMATTED_STATUS[3]
        end
      end
    end

    describe "a complaint that is more than a week old" do
      let(:complaint) { {status: {id: 0}, creationDate: 1.month.ago} }

      describe "an open complaint" do
        it "returns 'In Progress' as the formatted status" do
          expect(status(complaint)).to eq "In Progress"
        end
      end

      describe "a complaint that is not open" do
        it "returns the formatted status of the complaint's status " do
          complaint[:status] = {id: 2}
          expect(status(complaint)).to eq ComplaintsHelper::FORMATTED_STATUS[2]
        end
      end
    end
  end
end
