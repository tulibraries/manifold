# frozen_string_literal: true

require "rails_helper"

RSpec.describe "policies/index", type: :view do
  before(:each) do
    assign(:policies, [
      Policy.create!(
        name: "Name",
        description: "MyText",
        effective_date: "2018-01-01"
      ),
      Policy.create!(
        name: "Name",
        description: "MyText",
        effective_date: "2018-01-01",
        expiration_date: "2018-12-31"
      )
    ])
  end

  it "renders a list of policies" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "2018-01-01".to_s, count: 2
    assert_select "tr>td", text: "2018-12-31".to_s, count: 1
  end
end
