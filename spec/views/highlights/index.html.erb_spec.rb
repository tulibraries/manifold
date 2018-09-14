require 'rails_helper'

RSpec.describe "highlights/index", type: :view do
  before(:each) do
    assign(:highlights, [
      Highlight.create!(
        :title => "Title",
        :blurb => "MyText",
        :link => "Link",
        :type => "Type",
        :tags => "Tags"
      ),
      Highlight.create!(
        :title => "Title",
        :blurb => "MyText",
        :link => "Link",
        :type => "Type",
        :tags => "Tags"
      )
    ])
  end

  it "renders a list of highlights" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Link".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "Tags".to_s, :count => 2
  end
end
