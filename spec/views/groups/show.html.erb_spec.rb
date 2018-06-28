require 'rails_helper'

RSpec.describe "groups/show.html.erb", type: :view do
  it "displays the sample group name" do
    @group = FactoryBot.create(:group)
    render
    expect(rendered).to match /#{@group.name}/
  end

  it "displays the person" do
    @group = FactoryBot.create(:group_with_people)
    render
    expect(rendered).to match /#{Person.last.last_name}/
  end

  it "displays the building" do
    @group = FactoryBot.create(:group_with_buildings)
    render
    expect(rendered).to match /#{Building.last.name}/
  end

  it "displays the space" do
    @group = FactoryBot.create(:group_with_spaces)
    render
    expect(rendered).to match /#{Space.last.name}/
  end
end
