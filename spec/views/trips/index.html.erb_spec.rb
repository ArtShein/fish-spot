require "rails_helper"

RSpec.describe "trips/index", type: :view do
  let(:user) { User.create!(email: "trips-index@example.com", password: "password123456") }
  let(:location) do
    Location.create!(
      user: user,
      name: "Lake",
      latitude: 50.45,
      longitude: 30.52
    )
  end

  before do
    assign(:trips, [
      Trip.create!(user: user, location: location, name: "Trip A"),
      Trip.create!(user: user, location: location, name: "Trip B")
    ])
  end

  it "renders a list of trip cards" do
    render
    assert_select "article", count: 2
    assert_select "h2", text: /Trip A/
    assert_select "h2", text: /Trip B/
  end
end
