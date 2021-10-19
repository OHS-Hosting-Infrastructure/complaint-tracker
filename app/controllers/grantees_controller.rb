class GranteesController < ApplicationController
  # GET /grantees/1 or /grantees/1.json
  def show
    @grantee = Grantee.new(
      hses_grantee: Api::FakeData::Grantee.new(id: params[:id]).data
    )

    render layout: "details"
  end
end
