class GranteesController < ApplicationController
  before_action :set_grantee, only: %i[show]

  # GET /grantees/1 or /grantees/1.json
  def show
    render layout: "details"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grantee
    @grantee = Grantee.new(
      Api::FakeData::Grantee.new.data
    )
  end
end
