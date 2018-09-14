require 'rails_helper'

RSpec.describe "highlights/edit", type: :view do
  before(:each) do
    @highlight = assign(:highlight, Highlight.create!(
      :title => "MyString",
      :blurb => "MyText",
      :link => "MyString",
      :type => "",
      :tags => "MyString"
    ))
  end

  it "renders the edit highlight form" do
    render

    assert_select "form[action=?][method=?]", highlight_path(@highlight), "post" do

      assert_select "input[name=?]", "highlight[title]"

      assert_select "textarea[name=?]", "highlight[blurb]"

      assert_select "input[name=?]", "highlight[link]"

      assert_select "input[name=?]", "highlight[type]"

      assert_select "input[name=?]", "highlight[tags]"
    end
  end
end
