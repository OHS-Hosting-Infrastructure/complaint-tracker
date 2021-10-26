module ApplicationHelper
  def current_user
    @current_user ||= session[:user]&.with_indifferent_access
  end

  def user_signed_in?
    !!current_user
  end
end
