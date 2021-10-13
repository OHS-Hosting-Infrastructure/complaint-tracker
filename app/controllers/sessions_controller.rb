class SessionsController < ApplicationController
  skip_before_action :require_user!

  def create
    session["user"] = {
      uid: auth_info["uid"],
      name: auth_info["info"]["name"]
    }.with_indifferent_access
    session["hses_access_token"] = auth_info["credentials"]
    Rails.logger.debug { "Got auth_info: #{JSON.pretty_generate(auth_info)}" }
    redirect_to user_root_path
  end

  def destroy
    reset_session
    msg = "You are now logged out of the complaints tracker."
    msg += "<br><em>Note: you may still be logged in to HSES</em>"
    flash[:notice] = msg
    redirect_to root_path
  end

  private

  def auth_info
    request.env["omniauth.auth"]
  end
end
