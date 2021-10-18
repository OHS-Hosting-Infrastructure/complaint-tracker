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

  it "displays the grantee number and region in an h2" do
    expect(rendered).to match "<h2>Grantee ##{grantee.id}, Region #{grantee.region}</h2>"
  end

  it "displays the summary card" do
    expect(rendered).to match "<h2>Summary</h2>"
  end

  it "displays the complaints list" do
    expect(rendered).to match '<ul class="usa-process-list">'
  end
end
