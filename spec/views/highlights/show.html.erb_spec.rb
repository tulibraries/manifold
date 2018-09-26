require 'rails_helper'
include ActionDispatch::TestProcess

RSpec.describe "highlights/show", type: :view do
  before(:each) do
    @highlight = assign(:highlight, Highlight.create!(
      :title => "Title",
      :blurb => "MyText",
      :link => "Link",
      :highlight_type => "Type",
      :tags => "Tags"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Link/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/Tags/)
  end
end
