class ApplicationController < ActionController::Base
  private

  def require_user!
    unless helpers.user_signed_in?
      redirect_to root_path, alert: "You must log in first"
    end
  end

  def user_root_path
    complaints_path
  end
end
