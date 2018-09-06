require 'rails_helper'

RSpec.describe "library_hours/show", type: :view do
  before(:each) do
    @library_hours = assign(:library_hours, LibraryHours.create!(
      :location => "Location",
      :hours => "Hours"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/Hours/)
  end
end
