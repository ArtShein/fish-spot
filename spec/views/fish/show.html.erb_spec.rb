require 'rails_helper'

RSpec.describe "fish/show", type: :view do
  before(:each) do
    assign(:fish, Fish.create!(
      name: "Name",
      quantity: 2,
      kind: :predator,
      weight: 4.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Predator/)
    expect(rendered).to match(/4.5/)
  end
end
