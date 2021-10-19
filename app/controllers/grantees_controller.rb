class GranteesController < ApplicationController
  # GET /grantees/1 or /grantees/1.json
  def show
    @grantee = Grantee.new(
      Api::FakeData::Grantee.new.data
    )

    render layout: "details"
  end
end
