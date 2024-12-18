require 'rails_helper'

RSpec.describe "trips/new", type: :view do
  before(:each) do
    assign(:trip, Trip.new(
      name: "MyString"
    ))
  end

  it "renders new session form" do
    render

    assert_select "form[action=?][method=?]", trips_path, "post" do
      assert_select "input[name=?]", "trip[name]"
    end
  end
end
