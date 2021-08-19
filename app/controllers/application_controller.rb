class ApplicationController < ActionController::Base
  before_action :require_user!

  def require_user!
    return if helpers.user_signed_in?
    return if bypass_local_auth?
    redirect_to root_path, alert: "You must log in first"
  end

  def user_root_path
    complaints_path
  end

  def bypass_local_auth?
    return false if Rails.env.production?
    if ENV["BYPASS_AUTH"] == "true"
      session["user"] ||= {
        uid: ENV.fetch("CURRENT_USER_UID", "fake.testuser@test.com"),
        name: ENV.fetch("CURRENT_USER_NAME", "Fake Test-User")
      }.with_indifferent_access
      return true
    end
    false
  end
end
