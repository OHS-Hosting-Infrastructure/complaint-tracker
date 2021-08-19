class ComplaintsController < ApplicationController
  def index
    @complaints = FakeData::ApiResponse.hses_issues_response[:data]
  end

  def show
    @complaint = FakeData::ApiResponse.hses_issue_response(params[:id])[:data]
    render layout: "details"
  end
end
