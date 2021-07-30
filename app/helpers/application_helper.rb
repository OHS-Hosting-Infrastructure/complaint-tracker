module ApplicationHelper
  def current_user
    @current_user ||= session["username"]
  end

  def user_signed_in?
    !!current_user
  end
end
