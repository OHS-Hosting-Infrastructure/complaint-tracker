require "rails_helper"

RSpec.describe "grantees/show", type: :view do
  let(:grantee) { Grantee.new(Api::FakeData::Grantee.new.data) }

  it "renders attributes in <p>" do
    render
  end
end
