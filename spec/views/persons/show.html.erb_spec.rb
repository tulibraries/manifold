require 'rails_helper'

RSpec.describe "persons/show.html.erb", type: :view do
  it "displays the sample person's last name" do
    building = FactoryBot.create(:building) 
    space = FactoryBot.build(:space)
    space.building_id = building.id
    space.save!

    @person = FactoryBot.build(:person)
    @person.space_id = space.id
    @person.save!
    @person
    render
    expect(rendered).to match /#{@person.last_name}/
  end
end
