require 'rails_helper'

RSpec.describe "fish/index", type: :view do
  before(:each) do
    assign(:fish, [
      Fish.create!(
        name: "Name",
        quantity: 2,
        type: 3,
        weight: 4.5
      ),
      Fish.create!(
        name: "Name",
        quantity: 2,
        type: 3,
        weight: 4.5
      )
    ])
  end

  it "renders a list of fish" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.5.to_s), count: 2
  end
end
