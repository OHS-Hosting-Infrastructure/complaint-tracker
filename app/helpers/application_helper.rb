module ApplicationHelper
  def current_user
    @current_user ||= session[:user]
  end

  def user_signed_in?
    !!current_user
  end
end
