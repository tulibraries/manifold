# frozen_string_literal: true

require "rails_helper"

RSpec.describe "policies/show", type: :view do
  before(:each) do
    @policy = assign(:policy,
      Policy.create!(
        name: "Name",
        description: "MyText",
        effective_date: "2018-01-01",
        expiration_date: "2018-12-31"
      ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2018-01-01/)
    expect(rendered).to match(/2018-12-31/)
  end
end
