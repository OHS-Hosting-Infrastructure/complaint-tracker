require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    context "user is not logged in" do
      it "returns http success" do
        get root_path
        expect(response).to have_http_status(:success)
      end
    end

    context "user is logged in" do
      let(:user) {
        {
          name: "Request Spec",
          uid: "request.spec@test.com"
        }.with_indifferent_access
      }

      before do
        # There are some other session requests before getting to session["user"]
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[])
        allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).with("user").and_return user
      end

      it "redirects to the complaints list" do
        get root_path
        expect(response).to redirect_to(complaints_path)
      end
    end
  end
end
