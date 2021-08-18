class ComplaintsController < ApplicationController
  before_action :require_user!

  def index
    @complaints = FakeData::ApiResponse.generate_hses_issues_response[:data]
  end
end
