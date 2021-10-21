require "api_delegator"

class GranteesController < ApplicationController
  # GET /grantees/1 or /grantees/1.json
  def show
    @grantee = Grantee.new(
      hses_grantee: ApiDelegator.use("hses", "grantee", {id: params[:id]}).request.data
    )

    render layout: "details"
  end
end
