require "api_delegator"

class ComplaintsController < ApplicationController
  include Pagy::Backend
  include NeedsHsesAccessToken

  before_action :check_pa11y_id, only: :show, if: -> { Rails.env.ci? }

  def index
    res = ApiDelegator.use("hses", "issues", options_index).request

    @complaints = res.data
    @error = res.error
    @pagy = Pagy.new(count: res.count, page: params[:page])
  end

  def show
    @complaint = Complaint.new(
      ApiDelegator.use("hses", "issue", {id: params[:id]}).request.data
    )
    @issue_tta_reports = IssueTtaReport.where(issue_id: params[:id]).order(:start_date).each do |report|
      # inject the user's HSES access token to be used by TtaActivityReport
      report.access_token = hses_access_token
    end
    @timeline = Timeline.new(@complaint.attributes, @issue_tta_reports)
    render layout: "details"
  end

  private

  def check_pa11y_id
    if params[:id] == "pa11y-id"
      params[:id] = ApiDelegator
        .use("hses", "issues", {user: session[:user]})
        .request.data.first[:id]
    end
  end

  def options_index
    {user: session[:user], params: params}
  end
end
