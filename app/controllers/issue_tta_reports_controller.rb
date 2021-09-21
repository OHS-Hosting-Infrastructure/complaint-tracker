class IssueTtaReportsController < ApplicationController
  def create
    @issue_tta_report = IssueTtaReport.new(
      issue_id: params[:issue_id],
      tta_report_display_id: tta_report_id,
      tta_report_id: activity_data[:id]
    )

    if @issue_tta_report.save
      redirect_to complaint_path(params[:issue_id])
    end
  end

  private

  def activity_data
    Api.request("tta", "activity_report", {display_id: tta_report_id})[:data]
  end

  def tta_report_id
    params[:tta_report_id]
  end
end
