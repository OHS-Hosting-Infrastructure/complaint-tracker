class Timeline
  attr_reader :complaint_events

  EVENT_LABELS = {
    issueLastUpdated: "Updated",
    creationDate: "Created in HSES",
    closedDate: "Closed",
    reopenedDate: "Reopened",
    initialContactDate: "Initial contact from complaint"
  }.with_indifferent_access.freeze

  def initialize(complaint_attributes, tta_reports)
    @complaint_events = needed_attributes(complaint_attributes)
      .map { |event| ComplaintEvent.new(event) }

    @tta_events = tta_reports.map { |report| TtaEvent.new(report) }
  end

  def events
    @events ||= all_events
      .sort_by(&:date)
      .reverse
  end

  private

  def all_events
    @complaint_events + @tta_events
  end

  def needed_attributes(attributes)
    attributes.select do |key, value|
      EVENT_LABELS.key?(key) && value.present?
    end
  end
end

class Event
  attr_reader :date, :name

  def formatted_date
    date.strftime("%m/%d/%Y")
  end

  def timeline_partial
    "generic_timeline_event"
  end
end

class Timeline::ComplaintEvent < Event
  def initialize(event)
    @name = event[0]
    @date = Date.parse(event[1])
  end

  def label
    Timeline::EVENT_LABELS[name] || "Updated"
  end
end

class Timeline::TtaEvent < Event
  include ActionView::Helpers::TagHelper

  attr_reader :tta_activity_report
  delegate :api_error_message, :author_name, to: :tta_activity_report

  def initialize(issue_tta_report)
    @name = issue_tta_report.tta_report_display_id
    @date = issue_tta_report.start_date
    @tta_activity_report = issue_tta_report.tta_activity_report
  end

  def api_call_succeeded?
    tta_activity_report.valid?
  end

  def hub_link
    # using content_tag for the link will properly escape any dangerous characters that sneak into name or ttahub_url
    content_tag(:a, name, class: "usa-link", href: tta_activity_report.ttahub_url, target: "_blank")
  rescue Api::Error
    name
  end

  def topics_string
    tta_activity_report.topics.join(", ")
  end

  def timeline_partial
    "tta_timeline_event"
  end
end
