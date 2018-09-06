require 'rails_helper'

RSpec.describe "library_hours/edit", type: :view do
  before(:each) do
    @library_hours = assign(:library_hours, LibraryHours.create!(
      :location => "MyString",
      :hours => "MyString"
    ))
  end

  it "renders the edit library_hours form" do
    render

    assert_select "form[action=?][method=?]", library_hours_path(@library_hours), "post" do

      assert_select "input[name=?]", "library_hours[location]"

      assert_select "input[name=?]", "library_hours[hours]"
    end
  end
end
