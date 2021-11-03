module ComplaintsHelper
  include Pagy::Frontend

  STATUS_SORT_ORDER = {
    "New" => 0,
    "Rec. Reopening" => 1,
    "Reopened" => 2,
    "In Progress" => 3,
    "Rec. Closure" => 4,
    "Closed" => 5
  }

  def page_link(page, current: false)
    options = {
      class: page_link_class(current),
      "aria-label": page_link_label(page)
    }
    options["aria-current"] = "page" if current

    link_to page, complaints_path(page: page), options
  end

  def page_link_class(current)
    current ? "usa-pagination__button usa-current" : "usa-pagination__button"
  end

  def page_link_label(page)
    page == @pagy.series.last ? "Last page, page #{page}" : "Page #{page}"
  end

  def sort_date(date)
    date.to_datetime.to_i
  end

  def sort_status(status_label)
    STATUS_SORT_ORDER[status_label]
  end

  def aria_sort(column)
    current_sort_direction = current_sort_direction(column)
    if current_sort_direction.present?
      "aria-sort=\"#{current_sort_direction}\""
    end
  end

  def current_sort_direction(column)
    if @sort.nil?
      column == "creationDate" ? "descending" : nil
    else
      match = @sort.match(/(-)?#{column}/)
      if match
        match[1] == "-" ? "descending" : "ascending"
      end
    end
  end
end
