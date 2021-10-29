class IssueTtaReportsController < ApplicationController
  include NeedsHsesAccessToken

  def create
    @issue_tta_report = IssueTtaReport.new(
      issue_id: issue_id,
      tta_report_display_id: tta_report_display_id,
      access_token: hses_access_token
    )

    respond_to do |format|
      if @issue_tta_report.save
        format.js { render inline: "location.reload(true);" }
      else
        format.js { render "create_errors" }
      end
    end
  end

  def update
    @issue_tta_report = IssueTtaReport.find(params[:id])

    respond_to do |format|
      if @issue_tta_report.update(tta_report_display_id: tta_report_display_id, access_token: hses_access_token)
        format.js { render inline: "location.reload(true);" }
      else
        format.js { render "update_errors" }
      end
    end
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
    params[:issue_id_tta]
  end
end
