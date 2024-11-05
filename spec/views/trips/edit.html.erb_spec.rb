require 'rails_helper'

RSpec.describe "trips/edit", type: :view do
  let(:trip) {
    Trip.create!(
      name: "MyString"
    )
  }

  before(:each) do
    assign(:trip, trip)
  end

  it "renders the edit session form" do
    render

    assert_select "form[action=?][method=?]", trip_path(trip), "post" do

      assert_select "input[name=?]", "trip[name]"
    end
  end
end
