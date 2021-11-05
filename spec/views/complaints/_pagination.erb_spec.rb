require "rails_helper"

RSpec.describe "rendering pagination" do
  context "when multiple pages" do
    it "returns pagination and selects first page if none set" do
      @pagy = Pagy.new(count: 250)

      render partial: "complaints/pagination", locals: {pagy: @pagy, path_args: {}}
      expect(rendered).to include '<nav aria-label="pagination" class="usa-pagination">'
      expect(rendered).to include '<a class="usa-pagination__button usa-current" aria-label="Page 1" aria-current="page" href="/complaints?page=1">1</a>'
    end

    it "generates proper link for previous page" do
      @pagy = Pagy.new(count: 250, page: 2)

      render partial: "complaints/pagination", locals: {pagy: @pagy, path_args: {sort: "creationDate"}}
      expect(rendered).to include '<a class="usa-pagination__link usa-pagination__previous-page" aria-label="Previous page" href="/complaints?page=1&amp;sort=creationDate">'
    end

    it "generates proper link for next page" do
      @pagy = Pagy.new(count: 250)

      render partial: "complaints/pagination", locals: {pagy: @pagy, path_args: {sort: "creationDate"}}
      expect(rendered).to include '<a class="usa-pagination__link usa-pagination__next-page" aria-label="Next page" href="/complaints?page=2&amp;sort=creationDate">'
    end

    it "selects appropriate page" do
      @pagy = Pagy.new(count: 250, page: 5)

      render partial: "complaints/pagination", locals: {pagy: @pagy, path_args: {}}
      expect(rendered).to include '<a class="usa-pagination__button usa-current" aria-label="Page 5" aria-current="page" href="/complaints?page=5">5</a>'
    end
  end

  context "when one page" do
    it "has no pagination" do
      @pagy = Pagy.new(count: 25)

      render partial: "complaints/pagination", locals: {pagy: @pagy, path_args: {}}
      expect(rendered).not_to include '<nav aria-label="pagination" class="usa-pagination">'
    end
  end
end
