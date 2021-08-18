class ComplaintsController < ApplicationController
  @@hses_issues = FakeData::ApiResponse.generate_hses_issues_response[:data]

  def index
    @complaints = @@hses_issues
  end
end
