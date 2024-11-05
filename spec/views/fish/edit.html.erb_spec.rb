require 'rails_helper'

RSpec.describe "fish/edit", type: :view do
  let(:fish) {
    Fish.create!(
      name: "MyString",
      quantity: 1,
      type: 1,
      weight: 1.5
    )
  }

  before(:each) do
    assign(:fish, fish)
  end

  it "renders the edit fish form" do
    render

    assert_select "form[action=?][method=?]", fish_path(fish), "post" do

      assert_select "input[name=?]", "fish[name]"

      assert_select "input[name=?]", "fish[quantity]"

      assert_select "input[name=?]", "fish[type]"

      assert_select "input[name=?]", "fish[weight]"
    end
  end
end
