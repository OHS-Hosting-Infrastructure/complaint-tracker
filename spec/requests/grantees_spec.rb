require "rails_helper"

RSpec.describe "/grantees", type: :request do
  describe "GET /show" do
    let(:grant_id) { "fake-grantee-123" }

    it "returns a 200 status" do
      get grantee_path(id: grant_id)
      expect(response).to have_http_status(200)
    end
  end
end
