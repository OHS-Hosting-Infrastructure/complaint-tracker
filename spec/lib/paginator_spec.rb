require "rails_helper"
require "paginator"

RSpec.describe Paginator do
  describe "#initialize" do
    it "sets the current and total pages" do
      pager = Paginator.new(1, 10)
      expect(pager.current).to eq 1
      expect(pager.total).to eq 10
    end
  end

  describe "#pages" do
    context "with 1 page of results and no page selected" do
      it "returns empty set" do
        pages = Paginator.new(nil, 1).pages
        expect(pages).to eq []
      end
    end

    context "with 1 page of results and 1 page selected" do
      it "returns empty set" do
        pages = Paginator.new(1, 1).pages
        expect(pages).to eq []
      end
    end

    context "with 2 pages of results" do
      it "returns two pages" do
        pages = Paginator.new(1, 2).pages
        expect(pages).to eq [1, 2]
      end
    end

    context "with 3 pages of results" do
      it "returns three pages" do
        pages = Paginator.new(1, 3).pages
        expect(pages).to eq [1, 2, 3]
      end
    end

    context "with 4 pages of results" do
      it "returns four pages" do
        pages = Paginator.new(1, 4).pages
        expect(pages).to eq [1, 2, 3, 4]
      end
    end

    context "with 5 pages of results" do
      it "returns four pages" do
        pages = Paginator.new(1, 5).pages
        expect(pages).to eq [1, 2, 3, "|", 5]
      end
    end

    context "with 10 pages of results and first selected" do
      it "returns first several, spacer, then last page" do
        pages = Paginator.new(1, 10).pages
        expect(pages).to eq [1, 2, 3, "|", 10]
      end
    end

    context "with 10 pages of results and 4th selected" do
      it "returns 1st through 6th, spacer, then last page" do
        pages = Paginator.new(4, 10).pages
        expect(pages).to eq [1, 2, 3, 4, 5, 6, "|", 10]
      end
    end

    context "with 10 pages of results and 7th selected" do
      it "returns 1st, spacer, 5th through 10th" do
        pages = Paginator.new(7, 10).pages
        expect(pages).to eq [1, "|", 5, 6, 7, 8, 9, 10]
      end
    end

    context "with 10 pages of results and 10th selected" do
      it "returns 1st page, spacer, then 8, 9, 10" do
        pages = Paginator.new(10, 10).pages
        expect(pages).to eq [1, "|", 8, 9, 10]
      end
    end
  end
end
