class IssueTtaReportsController < ApplicationController
  def create
    @issue_tta_report = IssueTtaReport.new(
      issue_id: issue_id,
      tta_report_display_id: tta_report_display_id,
      tta_report_id: activity_data[:id]
    )

    if @issue_tta_report.save
      redirect_to complaint_path(issue_id)
    end
  end

  def update
    report = IssueTtaReport.find(params[:id])
    if report.update(
      tta_report_display_id: tta_report_display_id,
      tta_report_id: activity_data[:id]
    )
      redirect_to complaint_path(issue_id)
    end
  end

  def unlink
    tta_report_link = IssueTtaReport.find_by(issue_id: issue_id, tta_report_display_id: tta_report_display_id)
    tta_report_link.destroy!
    redirect_back fallback_location: complaint_path(issue_id)
  end

  private

  def activity_data
    api = ApiDelegator.use(
      "tta",
      "activity_report",
      {
        display_id: tta_report_display_id,
        access_token: HsesAccessToken.new(session["hses_access_token"])
      }
    )
    api.request[:data]
  end

  def tta_report_display_id
    params[:tta_report_display_id]
  end

  def issue_id
    params[:issue_id]
  end
end
