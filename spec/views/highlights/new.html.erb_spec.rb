require 'rails_helper'

RSpec.describe "highlights/new", type: :view do
  before(:each) do
    assign(:highlight, Highlight.new(
      :title => "MyString",
      :blurb => "MyText",
      :link => "MyString",
      :type => "",
      :tags => "MyString"
    ))
  end

  it "renders new highlight form" do
    render

    assert_select "form[action=?][method=?]", highlights_path, "post" do

      assert_select "input[name=?]", "highlight[title]"

      assert_select "textarea[name=?]", "highlight[blurb]"

      assert_select "input[name=?]", "highlight[link]"

      assert_select "input[name=?]", "highlight[type]"

      assert_select "input[name=?]", "highlight[tags]"
    end
  end
end
