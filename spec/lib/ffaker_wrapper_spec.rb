require "rails_helper"
require "ffaker_wrapper"

RSpec.describe FfakerWrapper do
  let(:test_class) { Class.new { extend FfakerWrapper } }
  describe "#date" do
    it "returns a random date object" do
      expect(test_class.date).to be_a Date
    end
  end

  describe "#date_string" do
    it "returns a random date string formatted as YYYY-MM-DD" do
      date = test_class.date_string
      expect(date).to be_a(String)
      expect(date.to_date).to be_a Date
    end
  end

  describe "#datetime" do
    it "returns a random datetime" do
      expect(test_class.datetime).to be_a DateTime
    end
  end

  describe "#datetime_string" do
    it "returns a string formatted as ISO-8601 UTC datetime" do
      dt = test_class.datetime_string
      expect(dt).to be_a(String)
      expect(Time.iso8601(dt)).to be_a Time
    end
  end

  describe "#grantee_name" do
    it "returns a string" do
      expect(test_class.grantee_name).to be_a String
    end
  end

  describe "#grant_number" do
    it "returns a string of numbers" do
      expect(test_class.grant_number).to be_a String
    end
  end

  describe "#identifier" do
    it "returns a string" do
      expect(test_class.identifier).to be_a String
    end
  end

  describe "#issue_type_object" do
    it "returns an issue type object with an id and label" do
      obj = test_class.issue_type_object
      expect(obj[:id]).to be_a Integer
      expect(obj[:label]).to be_a String
    end
  end

  describe "#phrase" do
    it "returns a sentence" do
      phrase = test_class.phrase
      expect(phrase).to be_a String
      expect(phrase).to match /\s+/
    end
  end

  describe "#priority_object" do
    it "returns a priority object with an id and label" do
      obj = test_class.priority_object
      expect(obj[:id]).to be_a Integer
      expect(obj[:label]).to be_a String
    end
  end

  describe "#random_int" do
    describe "no value passed in" do
      it "returns a random integer between 0 and 3" do
        expect(test_class.random_int).to be_between(0, 3).inclusive
      end
    end

    describe "with a value passed in" do
      it "returns a random integer between 0 and that number" do
        expect(test_class.random_int(5)).to be_between(0, 5).inclusive
        expect(test_class.random_int(1)).to be_between(0, 1).inclusive
      end
    end
  end

  describe "#regarding" do
    it "returns a string" do
      expect(test_class.regarding).to be_a String
    end
  end

  describe "#status_object" do
    it "returns a status object with an id and label" do
      obj = test_class.status_object
      expect(obj[:id]).to be_a Integer
      expect(obj[:label]).to be_a String
    end
  end
end
