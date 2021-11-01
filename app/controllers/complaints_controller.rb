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
    @issue_tta_reports = inject_access_token(IssueTtaReport)
    @issue_monitoring_reviews = inject_access_token(IssueMonitoringReview)

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

  def inject_access_token(model)
    model.where(issue_id: params[:id]).order(:start_date).each do |record|
      # inject the user's HSES access token to be used by the TTA report or monitoring review
      record.access_token = hses_access_token
    end
  end

  def options_index
    {user: session[:user], params: params}
  end
end
