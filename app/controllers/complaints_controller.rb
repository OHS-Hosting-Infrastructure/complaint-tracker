require "api_delegator"

class ComplaintsController < ApplicationController
  before_action :check_pa11y_id, only: :show, if: -> { Rails.env.ci? }

  def index
    options = {user: session["user"], params: params}
    api = ApiDelegator.use("hses", "issues", options)
    req = api.request

    @complaints = req.data
    @page_total = req.page_total
  end

  def show
    @complaint = Complaint.new(
      ApiDelegator.use("hses", "issue", {id: params[:id]}).request.data
    )
    @issue_tta_reports = IssueTtaReport.where(issue_id: params[:id]).order(:start_date)
    @timeline = Timeline.new(@complaint.attributes, @issue_tta_reports)
    render layout: "details"
  end

  private

  def check_pa11y_id
    if params[:id] == "pa11y-id"
      params[:id] = ApiDelegator
        .use("hses", "issues", {user: session["user"]})
        .request.data.first[:id]
    end
  end
end
