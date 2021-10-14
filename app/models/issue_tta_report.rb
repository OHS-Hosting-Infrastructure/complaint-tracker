class IssueTtaReport < ApplicationRecord
  before_validation :retrieve_tta_report_details
  validates :issue_id, :tta_report_display_id, presence: true
  validates :tta_report_display_id, uniqueness: {scope: :issue_id}
  validate :tta_activity_report_valid, if: :tta_report_display_id_changed?
  # tta_report_id presence validation is skipped if any other errors are found
  # the user cant do much about this anyway since it is derived from the tta_report_display_id
  validates :tta_report_id, :start_date, presence: true, if: :errors_blank?

  attr_accessor :access_token

  def tta_activity_report
    @tta_activity_report ||= TtaActivityReport.new(tta_report_display_id, access_token)
  end

  private

  def tta_activity_report_valid
    errors.add(:base, tta_activity_report.api_error_message) unless tta_activity_report.valid?
  end

  def errors_blank?
    errors.blank?
  end

  def retrieve_tta_report_details
    if tta_report_display_id_changed? && tta_activity_report.valid?
      self.tta_report_id = tta_activity_report.id
      self.start_date = tta_activity_report.start_date
    end
  end
end
