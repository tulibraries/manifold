require 'rails_helper'

RSpec.describe "events/new", type: :view do
  before(:each) do
    assign(:event, Event.new(
      :title => "MyString",
      :blurb => "MyText",
      :link => "MyString",
      :type => "",
      :tags => "MyString"
    ))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "input[name=?]", "event[title]"

      assert_select "textarea[name=?]", "event[blurb]"

      assert_select "input[name=?]", "event[link]"

      assert_select "input[name=?]", "event[type]"

      assert_select "input[name=?]", "event[tags]"
    end
  end
end
