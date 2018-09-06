require 'rails_helper'

RSpec.describe "library_hours/new", type: :view do
  before(:each) do
    assign(:library_hours, LibraryHours.new(
      :location => "MyString",
      :hours => "MyString"
    ))
  end

  it "renders new library_hours form" do
    render

    assert_select "form[action=?][method=?]", library_hours_index_path, "post" do

      assert_select "input[name=?]", "library_hours[location]"

      assert_select "input[name=?]", "library_hours[hours]"
    end
  end
end
