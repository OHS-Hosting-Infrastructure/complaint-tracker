class Timeline::MonitoringEvent < Timeline::Event
  include ActionView::Helpers::TagHelper

  attr_reader :review
  delegate :api_error_message, :status, :review_type, :outcome,
    to: :review

  def initialize(issue_monitoring_review)
    @name = issue_monitoring_review.review_id
    @date = issue_monitoring_review.start_date
    @review = issue_monitoring_review.monitoring_review
  end

  def api_call_succeeded?
    review.valid?
  end

  def review_link
    # using content_tag for the link will properly escape any dangerous characters that sneak into name or monitoring url
    content_tag(:a, name, class: "usa-link", href: review.itams_url, target: "_blank")
  rescue Api::Error
    name
  end

  def timeline_partial
    "monitoring_timeline_event"
  end
end
