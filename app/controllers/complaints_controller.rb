class ComplaintsController < ApplicationController
  def index
    @complaints = FakeData::ApiResponse.generate_hses_issues_response[:data]
  end
end
