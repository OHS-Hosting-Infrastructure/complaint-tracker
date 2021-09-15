class IssueTtaReport < ApplicationRecord
  validates :issue_id, :tta_report_display_id, :tta_report_id, presence: true
  validates :tta_report_id, numericality: {only_integer: true}
end
