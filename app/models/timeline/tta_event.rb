class Timeline::TtaEvent < Timeline::Event
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
