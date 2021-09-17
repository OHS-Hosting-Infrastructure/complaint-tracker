class ComplaintsController < ApplicationController
  before_action :check_pa11y_id, only: :show, if: -> { Rails.env.ci? }

  def index
    @complaints = Api.request("hses", "issues")[:data]
  end

  def show
    @complaint = Complaint.new(Api.request("hses", "issue", {id: params[:id]})[:data])
    @tta_reports = IssueTtaReport.where(issue_id: params[:id])
    render layout: "details"
  end

  private

  def check_pa11y_id
    if params[:id] == "pa11y-id"
      params[:id] = Api.request("hses", "issues")[:data].first[:id]
    end
  end
end
