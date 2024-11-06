require 'rails_helper'

RSpec.describe "fish/new", type: :view do
  before(:each) do
    assign(:fish, Fish.new(
      name: "MyString",
      quantity: 1,
      type: 1,
      weight: 1.5
    ))
  end

  it "renders new fish form" do
    render

    assert_select "form[action=?][method=?]", fish_index_path, "post" do
      assert_select "input[name=?]", "fish[name]"

      assert_select "input[name=?]", "fish[quantity]"

      assert_select "input[name=?]", "fish[type]"

      assert_select "input[name=?]", "fish[weight]"
    end
  end
end
