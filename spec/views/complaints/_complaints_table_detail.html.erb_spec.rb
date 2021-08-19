require "rails_helper"

RSpec.describe "rendering complaints table" do
  let(:complaint) { FakeData::Complaint.new.data }
  describe "a new complaint" do
    it "has a bold id" do
      complaint[:attributes][:creationDate] = 1.day.ago.strftime("%FT%TZ")
      complaint[:attributes][:status] = 0
      complaint[:id] = "12345"

      render partial: "complaints/complaints_table_detail", locals: {complaint: complaint}
      expect(rendered.squish).to match '<span class="text-bold"> 12345 </span>'
    end
  end

  describe "an older complaint" do
    it "does not have a bold id" do
      complaint[:attributes][:creationDate] = 1.month.ago.strftime("%FT%TZ")
      complaint[:id] = "12345"

      render partial: "complaints/complaints_table_detail", locals: {complaint: complaint}
      expect(rendered.squish).to match '<span class=""> 12345 </span>'
    end
  end
end
