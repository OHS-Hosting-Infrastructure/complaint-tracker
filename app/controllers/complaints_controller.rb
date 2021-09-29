require "api_delegator"

class ComplaintsController < ApplicationController
  before_action :check_pa11y_id, only: :show, if: -> { Rails.env.ci? }

  def index
    api = ApiDelegator.use("hses", "issues", {user: session["user"]})
    @complaints = api.request[:data]
  end

  def show
    @complaint = Complaint.new(
      ApiDelegator.use("hses", "issue", {id: params[:id]}).request[:data]
    )
    @issue_tta_reports = IssueTtaReport.where(issue_id: params[:id])
    render layout: "details"
  end

  def unlink_tta_report
    tta_report_link = IssueTtaReport.find_by(issue_id: params[:id], tta_report_display_id: params[:tta_report_display_id])
    tta_report_link.destroy!
    redirect_back fallback_location: {action: "show", id: params[:id]}
  end

  private

  def check_pa11y_id
    if params[:id] == "pa11y-id"
      params[:id] = ApiDelegator
        .use("hses", "issues", {user: session["user"]})
        .request[:data]
        .first[:id]
    end
  end
end
