# frozen_string_literal: true

require "rails_helper"

RSpec.describe "buildings/show.html.erb", type: :view do
  it "displays the sample building name" do
    @building = FactoryBot.build(:building)
    stub_template "_searchfields.html.erb" => "This content"
    render
    expect(rendered).to match /#{@building.name}/
  end
end
