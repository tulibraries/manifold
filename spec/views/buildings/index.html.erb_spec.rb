# frozen_string_literal: true

require "rails_helper"

RSpec.describe "buildings/index.html.erb", type: :view do
  it "displays the building template" do
    @buildings = [ ]
    stub_template "_searchfields.html.erb" => "This content"
    render
    expect(rendered).to match /Buildings/
  end

  it "displays the sample building name" do
    @buildings = [ FactoryBot.build(:building) ]
    stub_template "_searchfields.html.erb" => "This content"
    render
    expect(rendered).to match /#{@buildings.first.name}/
  end
end
