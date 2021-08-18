class SessionsController < ApplicationController
  def create
    session["user"] = {
      uid: auth_info["uid"],
      name: auth_info["info"]["name"]
    }
    Rails.logger.debug { "Got auth_info: #{JSON.pretty_generate(auth_info)}" }
    redirect_to user_root_path
  end

  def destroy
    reset_session
    flash[:notice] = "You are now logged out"
    redirect_to root_path
  end

  private

  def auth_info
    request.env["omniauth.auth"]
  end
end
