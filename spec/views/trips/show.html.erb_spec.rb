require 'rails_helper'

RSpec.describe "trips/show", type: :view do
  before(:each) do
    assign(:trip, Trip.create!(
      name: "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
