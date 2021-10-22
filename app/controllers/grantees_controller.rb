class GranteesController < ApplicationController
  # GET /grantees/1 or /grantees/1.json
  def show
    @grantee = Grantee.new(params[:id])

    render layout: "details"
  end
end
