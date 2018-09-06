require 'rails_helper'

RSpec.describe "library_hours/index", type: :view do
  before(:each) do
    assign(:library_hours, [
      LibraryHours.create!(
        :location => "Location",
        :hours => "Hours"
      ),
      LibraryHours.create!(
        :location => "Location",
        :hours => "Hours"
      )
    ])
  end

  it "renders a list of library_hours" do
    render
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "Hours".to_s, :count => 2
  end
end
