require "api_delegator"

class IssueTtaReport < ApplicationRecord
  before_validation :retrieve_tta_report_details
  validates :issue_id, :tta_report_display_id, presence: true
  validates :tta_report_display_id, uniqueness: {scope: :issue_id}
  validate :api_call_succeeded
  # tta_report_id presence validation is skipped if any other errors are found
  # the user cant do much about this anyway since it is derived from the tta_report_display_id
  validates :tta_report_id, :start_date, presence: true, if: :errors_blank?

  attr_accessor :access_token

  private

  def api_call_succeeded
    # do not make the api call here, if @activity_data is nil then we didn't attempt to make a call
    if !@activity_data.nil? && @activity_data.failed?
      errors.add(:base, tta_link_error_message(@activity_data.code))
    end
  end

  def errors_blank?
    errors.blank?
  end

  def retrieve_tta_report_details
    if tta_report_display_id_changed? && activity_data.succeeded?
      activity_report_details = activity_data.data
      self.tta_report_id = activity_report_details[:id]
      self.start_date = activity_report_details[:attributes][:startDate]
    end
  end

  def activity_data
    @activity_data ||= api.request
  end

  def api
    ApiDelegator.use("tta", "activity_report", display_id: tta_report_display_id, access_token: access_token)
  end

  def tta_link_error_message(response_code)
    case response_code
    when 403
      "You do not have permission to access this activity report."
    when 404
      "This number doesn't match any existing activity reports. Please double-check the number."
    else
      "We're unable to look up reports in TTA Smart Hub right now. Please try again later."
    end
  end
end
