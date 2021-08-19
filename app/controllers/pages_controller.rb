class PagesController < ApplicationController
  skip_before_action :require_user!

  def welcome
    if helpers.user_signed_in?
      redirect_to user_root_path
    end
  end
end
