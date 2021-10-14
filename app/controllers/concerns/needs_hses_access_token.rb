module NeedsHsesAccessToken
  extend ActiveSupport::Concern

  private

  def hses_access_token
    @hses_access_token ||= HsesAccessToken.new(session["hses_access_token"])
  end
end
