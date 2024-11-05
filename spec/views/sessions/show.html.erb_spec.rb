require 'rails_helper'

RSpec.describe "sessions/show", type: :view do
  before(:each) do
    assign(:session, Session.create!(
      name: "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
