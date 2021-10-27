class IssueMonitoringReview < ApplicationRecord
  validates :issue_id, :review_id, :start_date, presence: true
  validates :review_id, uniqueness: {scope: :issue_id}
end
