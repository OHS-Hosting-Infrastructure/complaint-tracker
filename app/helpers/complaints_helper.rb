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

  def aria_sort(sort_value_for_column)
    current_sort_direction_for_column = current_sort_direction(sort_value_for_column)
    if current_sort_direction_for_column.present?
      "aria-sort=\"#{current_sort_direction_for_column}\""
    end
  end

  def current_sort_direction(sort_value_for_column)
    if @sort.nil? && sort_value_for_column == "creationDate"
      # Defaults to a descending creation date sort when no sort is specified
      "descending"
    elsif @sort.present?
      match = @sort.match(/(-)?#{sort_value_for_column}/)
      # if we don't have a match we're sorting by some other column, so return nil from this function
      if match
        # the current sort direction having a leading `-` means we're sorted descending
        match[1] == "-" ? "descending" : "ascending"
      end
    end
  end

  def next_sort_direction(sort_value_for_column)
    # sort descending (leading `-`) if currently unsorted or sorted ascending
    if current_sort_direction(sort_value_for_column) == "descending"
      sort_value_for_column
    else
      "-#{sort_value_for_column}"
    end
  end
end
