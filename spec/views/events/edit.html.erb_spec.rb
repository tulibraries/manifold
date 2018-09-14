require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :title => "MyString",
      :blurb => "MyText",
      :link => "MyString",
      :type => "",
      :tags => "MyString"
    ))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input[name=?]", "event[title]"

      assert_select "textarea[name=?]", "event[blurb]"

      assert_select "input[name=?]", "event[link]"

      assert_select "input[name=?]", "event[type]"

      assert_select "input[name=?]", "event[tags]"
    end
  end
end
