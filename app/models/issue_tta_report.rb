class IssueTtaReport < ApplicationRecord
  validates :issue_id, :tta_report_display_id, :tta_report_id, presence: true
  validates :tta_report_id, format: {with: /\A[0-9]*\z/, message: "only allows numbers"}
  validates :tta_report_display_id, uniqueness: {scope: :issue_id}
end
