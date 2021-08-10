class ComplaintsController < ApplicationController
  def index
    @complaints = FakeData::Complaints.generate_response
  end
end
