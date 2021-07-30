class SessionsController < ApplicationController
  def create
    session["username"] = auth_info["uid"]
    Rails.logger.debug { "Got auth_info: #{JSON.pretty_generate(auth_info)}" }
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def auth_info
    request.env["omniauth.auth"]
  end
end