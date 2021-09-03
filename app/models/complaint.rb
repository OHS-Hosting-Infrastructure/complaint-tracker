class Complaint
  attr_reader :id, :attributes

  EVENT_FIELDS = %w[
    issueLastUpdated
    creationDate
    closedDate
    reopenedDate
    initialContactDate
  ].freeze

  EVENT_LABELS = {
    issueLastUpdated: "Updated",
    creationDate: "Created in HSES",
    closedDate: "Closed",
    reopenedDate: "Reopened",
    initialContactDate: "Initial contact from complaint"
  }.with_indifferent_access.freeze

  def initialize(hses_complaint)
    @id = hses_complaint[:id]
    @attributes = hses_complaint[:attributes].with_indifferent_access
  end

  def events
    @events ||= mapped_events
      .sort_by { |events| events[:date] }
      .reverse
  end

  def event_label(attribute_name)
    EVENT_LABELS[attribute_name] || "Updated"
  end

  def grantee
    attributes["grantee"]
  end

  def issue
    attributes["issue"]
  end

  def due_date?
    due_date.present?
  end

  def overdue?
    due_date? && due_date.past?
  end

  def due_soon?
    due_date? && due_date < 1.week.from_now
  end

  def relative_due_date_string
    if due_date == Date.today
      "Due today (#{formatted_due_date})"
    else
      "Due in #{day_string} (#{formatted_due_date})"
    end
  end

  def formatted_due_date
    due_date.strftime("%-m/%-d/%Y")
  end

  private

  def relative_time_till_due
    (Date.today...due_date).count
  end

  def day_string
    ActionController::Base.helpers.pluralize(relative_time_till_due, "day")
  end

  def unsorted_needed_events
    attributes.select do |key, value|
      EVENT_FIELDS.include?(key) && value.present?
    end
  end

  def mapped_events
    unsorted_needed_events.map do |key, value|
      {
        name: key,
        date: Time.parse(value)
      }
    end
  end

  def due_date
    Date.parse(attributes[:dueDate])
  rescue
    nil
  end
end
