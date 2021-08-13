class ComplaintsController < ApplicationController
  def index
    @complaints = FakeData::ApiResponse.generate_hses_response[:data]
  end
end
