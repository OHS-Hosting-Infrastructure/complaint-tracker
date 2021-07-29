require "rails_helper"

RSpec.describe "Complaints", type: :request do
  describe "GET /index" do
    it "returns a 200 status" do
      get root_path
      expect(response).to have_http_status(200)
    end

    it "renders the text" do
      get root_path
      expect(response.body).to include("My complaints")
    end
  end
end
