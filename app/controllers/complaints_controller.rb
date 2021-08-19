class ComplaintsController < ApplicationController
  def index
    @complaints = FakeData::ApiResponse.hses_issues_response[:data]
  end
end
