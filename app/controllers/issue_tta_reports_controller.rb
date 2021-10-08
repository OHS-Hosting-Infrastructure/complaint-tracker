class IssueTtaReportsController < ApplicationController
  def create
    if activity_data[:success]
      activity_report = activity_data[:body][:data]
      @issue_tta_report = IssueTtaReport.new(
        issue_id: issue_id,
        tta_report_display_id: tta_report_display_id,
        tta_report_id: activity_report[:id]
      )

      if !@issue_tta_report.save
        flash[:tta_errors] = {
          display_id: tta_report_display_id,
          message: @issue_tta_report.errors.full_messages.join(". ")
        }
      end
    else
      flash[:tta_errors] = {
        display_id: tta_report_display_id,
        message: tta_link_error_message(activity_data[:code])
      }
    end
    redirect_to complaint_path(issue_id)
  end

  def update
    if activity_data[:success]
      activity_report = activity_data[:body][:data]
      report = IssueTtaReport.find(params[:id])
      if !report.update(
        tta_report_display_id: tta_report_display_id,
        tta_report_id: activity_report[:id]
      )

        flash[:tta_errors] = {
          display_id: tta_report_display_id,
          message: report.errors.full_messages.join(". ")
        }
      end
    else
      flash[:tta_errors] = {
        display_id: tta_report_display_id,
        message: tta_link_error_message(activity_data[:code])
      }
    end
    redirect_to complaint_path(issue_id)
  end

  def unlink
    tta_report_link = IssueTtaReport.find_by(issue_id: issue_id, tta_report_display_id: tta_report_display_id)
    tta_report_link.destroy!
    redirect_back fallback_location: complaint_path(issue_id)
  end

  private

  def activity_data
    @activity_data ||= api.request
  end

  def api
    ApiDelegator.use(
      "tta",
      "activity_report",
      {
        display_id: tta_report_display_id,
        access_token: HsesAccessToken.new(session["hses_access_token"])
      }
    )
  end

  def tta_report_display_id
    params[:tta_report_display_id]
  end

  def issue_id
    params[:issue_id]
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
