require 'rails_helper'

RSpec.describe "groups/show.html.erb", type: :view do
  it "displays the sample group name" do
    building = FactoryBot.create(:building) 
    space = FactoryBot.build(:space)
    space.building_id = building.id
    space.save!

    person = FactoryBot.build(:person)
    person.building_id = building.id
    person.space_id = space.id
    person.save!

    @group = FactoryBot.build(:group)
    @group.building_id = building.id
    @group.space_id = space.id
    @group.person_id = person.id
    @group.save!

    render
    expect(rendered).to match /#{@group.name}/
  end
end
