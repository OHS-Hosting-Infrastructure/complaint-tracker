class HsesAccessToken
  attr_reader :credentials

  def initialize(creds = {})
    @credentials = creds.dup.with_indifferent_access
    @credentials[:access_token] = @credentials.delete :token
    @credentials.delete :expires
  end

  def bearer_token
    access_token.token
  end

  private

  def access_token
    @access_token ||= OAuth2::AccessToken.from_hash(client, credentials)
    # always check if the memoized @access_token has expired since we've last used it
    # and refresh if necessary
    @access_token = @access_token.refresh! if @access_token.expired?
    @access_token
  end

  def client
    @client ||= OAuth2::Client.new(
      Rails.configuration.x.hses.client_id,
      Rails.configuration.x.hses.client_secret,
      OmniAuth::Strategies::HsesOauth::CLIENT_OPTIONS
    )
  end
end
