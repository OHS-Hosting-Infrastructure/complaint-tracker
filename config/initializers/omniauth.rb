module OmniAuth
  module Strategies
    class HsesOauth < OmniAuth::Strategies::OAuth2
      option :name, "hses"
      option :client_options, {
        site: Rails.configuration.x.hses.auth_base,
        token_url: "/auth/oauth/token",
        authorize_url: "/auth/oauth/authorize",
        auth_scheme: :basic_auth
      }
      option :callback_path, "/oauth2-client/login/oauth2/code/"
      option :scope, "user_info"

      uid { raw_info["username"] }
      info do
        {
          name: "#{raw_info["firstName"]} #{raw_info["lastName"]}",
          email: raw_info["email"],
          regions: raw_info["regions"],
          roles: raw_info["roles"],
          authorities: raw_info["authorities"]
        }
      end
      extra do
        {
          "raw_info" => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get("/auth/user/details").parsed
      end

      # superclass overrides to deal with issues found
      def on_callback_path?
        # path comparison was failing due to trailing / needed in callback_path option
        on_path?(callback_path.delete_suffix("/"))
      end

      def callback_url
        # path containing the query string was failing
        full_host + script_name + callback_path
      end
    end
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :hses_oauth, Rails.configuration.x.hses.client_id, Rails.configuration.x.hses.client_secret
end
