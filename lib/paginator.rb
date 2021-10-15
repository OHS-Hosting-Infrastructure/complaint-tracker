class Paginator
  PADDING = 2
  SEPARATOR = "|"

  attr_reader :current
  attr_reader :total

  def initialize(current, total)
    @current = current.to_i || 1
    @total = total
  end

  def pages
    @pages ||= build_pages
  end

  private

  def add_first_and_last_page
    @pages.unshift(1) if @total > 1
    @pages.push(@total) if @total > 1
    @pages.uniq!
  end

  def add_separators
    # add separator after page 1
    if @pages[1] != 2
      @pages.insert(1, SEPARATOR)
    end
    # add separator before the last page
    if @pages[-2] != @total - 1
      @pages.insert(pages[-2], SEPARATOR)
    end
  end

  def all_displayable?
    @total <= PADDING + 1
  end

  def all_pages
    # if there's only one page, we don't need pagination
    @total > 1 ? (1..@total).to_a.uniq : []
  end

  def build_pages
    if all_displayable?
      return all_pages
    end

    current_page_padding
    add_first_and_last_page
    add_separators
    @pages
  end

  def current_page_padding
    pages = ((@current - PADDING)..(@current + PADDING)).to_a
    # filter out negative pages and any that exceed total
    @pages = pages.select { |num| num > 0 && num < @total }
  end
end
