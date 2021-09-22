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
    @tta_reports = IssueTtaReport.where(issue_id: params[:id])
    render layout: "details"
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
