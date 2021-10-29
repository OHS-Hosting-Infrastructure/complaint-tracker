class IssueMonitoringReview < ApplicationRecord
  before_validation :retrieve_monitoring_review_details
  validates :issue_id, :review_id, :start_date, presence: true
  validates :review_id, uniqueness: {scope: :issue_id}

  attr_accessor :access_token

  def monitoring_review
    @monitoring_review ||= MonitoringReview.new(review_id, access_token)
  end

  private

  def retrieve_monitoring_review_details
    self.start_date = monitoring_review.start_date
  end
end
