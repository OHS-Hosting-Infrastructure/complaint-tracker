class ComplaintsController < ApplicationController
  before_action :check_pa11y_id, only: :show, if: -> { Rails.env.ci? }

  def index
    @complaints = FakeData::ApiResponse.hses_issues_response[:data]
  end

  def show
    @complaint = FakeData::ApiResponse.hses_issue_response(params[:id])[:data]
    render layout: "details"
  end

  private

  def check_pa11y_id
    if params[:id] == "pa11y-id"
      params[:id] = FakeData::ApiResponse.hses_issues_response[:data].first[:id]
    end
  end
end
