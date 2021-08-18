class PagesController < ApplicationController
  def welcome
    if helpers.user_signed_in?
      redirect_to user_root_path
    end
  end
end
