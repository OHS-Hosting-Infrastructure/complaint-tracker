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
    @timeline = Timeline.new(@complaint.attributes, tta_reports)
    render layout: "details"
  end

  private

  def tta_reports
    @issue_tta_reports.pluck(:tta_report_display_id).map do |id|
      response = ApiDelegator.use(
        "tta",
        "activity_report",
        {
          display_id: id,
          access_token: HsesAccessToken.new(session["hses_access_token"])
        }
      ).request
      response[:success] ? response[:body][:data] : nil
    end.compact
  end

  def check_pa11y_id
    if params[:id] == "pa11y-id"
      params[:id] = ApiDelegator
        .use("hses", "issues", {user: session["user"]})
        .request[:data]
        .first[:id]
    end
  end
end
