# frozen_string_literal: true

require "rails_helper"

RSpec.describe "spaces/show.html.erb", type: :view do
  it "displays the sample space name" do
    @space = FactoryBot.build(:space)
    building = FactoryBot.create(:building)
    @space.building_id = building.id
    render
    expect(rendered).to match /#{@space.name}/
  end
end
