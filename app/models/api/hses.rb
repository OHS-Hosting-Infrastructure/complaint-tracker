require "fake_api_response_wrapper"
require "fake_issues"

class Api::Hses
  class Issue
    include FakeApiResponseWrapper
    attr_accessor :id

    def initialize(id:)
      @id = id
    end

    def request
      details_wrapper.merge(
        data: FakeIssues.instance.json[:data].find { |c| c[:id] == @id }
      )
    end
  end

  class Issues
    def initialize(user:)
      @username = user["uid"]
    end

    def request
      uri = build_request_url
      res = send_request(uri)
      res.code == "200" ? format_response(res) : {}
    end

    private

    def build_request_url
      URI::HTTPS.build(
        host: Rails.configuration.x.hses.api,
        path: "/issues-ws/issues",
        query: "username=#{@username}&types=1"
      )
    end

    def format_response(res)
      JSON.parse(res.body).with_indifferent_access
    end

    def send_request(uri)
      req = Net::HTTP::Get.new(uri)
      req.basic_auth(
        Rails.configuration.x.hses.api_username,
        Rails.configuration.x.hses.api_password
      )

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end
    end
  end
end
