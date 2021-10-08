require "api_delegator"

class IssueTtaReport < ApplicationRecord
  validates :issue_id, :tta_report_display_id, presence: true
  validates :tta_report_display_id, uniqueness: {scope: :issue_id}
  validate :api_call_succeeded
  validates :tta_report_id, presence: true, if: :errors_blank?

  attr_accessor :access_token

  before_validation :retrieve_tta_report_id

  private

  def api_call_succeeded
    # do not make the api call here, if @activity_data is nil then we didn't attempt to make a call
    if !@activity_data.nil?
      if !activity_data[:success]
        errors.add(:base, tta_link_error_message(activity_data[:code]))
      end
    end
  end

  def errors_blank?
    errors.blank?
  end

  def retrieve_tta_report_id
    if tta_report_display_id_changed?
      if activity_data[:success]
        self.tta_report_id = activity_data[:body][:data][:id]
      end
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
