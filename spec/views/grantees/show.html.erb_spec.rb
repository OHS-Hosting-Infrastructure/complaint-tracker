require 'rails_helper'

RSpec.describe "grantees/show", type: :view do
  before(:each) do
    @grantee = assign(:grantee, Grantee.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
