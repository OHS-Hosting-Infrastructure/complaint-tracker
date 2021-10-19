class IssueTtaReportsController < ApplicationController
  include NeedsHsesAccessToken

  def create
    @issue_tta_report = IssueTtaReport.new(
      issue_id: issue_id,
      tta_report_display_id: tta_report_display_id,
      access_token: hses_access_token
    )

    if !@issue_tta_report.save
      flash[:tta_errors] = {
        display_id: tta_report_display_id,
        message: @issue_tta_report.errors.full_messages.join(". ")
      }
    end
    redirect_to complaint_path(issue_id)
  end

  def update
    report = IssueTtaReport.find(params[:id])

    if !report.update(tta_report_display_id: tta_report_display_id, access_token: hses_access_token)
      flash[:tta_errors] = {
        display_id: tta_report_display_id,
        message: report.errors.full_messages.join(". ")
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

  def tta_report_display_id
    params[:tta_report_display_id]
  end

  def issue_id
    params[:issue_id]
  end
end
