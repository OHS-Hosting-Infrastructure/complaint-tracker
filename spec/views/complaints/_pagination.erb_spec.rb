require "rails_helper"

RSpec.describe "rendering pagination" do
  context "when multiple pages" do
    it "returns pagination and selects first page if none set" do
      @pagy = Pagy.new(count: 250)

      render partial: "complaints/pagination", locals: {pagy: @pagy, path_args: {}}
      expect(rendered).to include '<nav aria-label="pagination" class="usa-pagination">'
      expect(rendered).to include '<a class="usa-pagination__button usa-current" aria-label="Page 1" aria-current="page" href="/complaints?page=1">1</a>'
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
