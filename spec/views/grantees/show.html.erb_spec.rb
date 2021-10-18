require "rails_helper"

RSpec.describe "grantees/show", type: :view do
  let(:grantee) { Grantee.new(Api::FakeData::Grantee.new.data) }

  before do
    assign(:grantee, grantee)
    render
  end

  it "displays the grantee name in an h1" do
    expect(rendered).to match "<h1>#{grantee.name}</h1>"
  end
end
