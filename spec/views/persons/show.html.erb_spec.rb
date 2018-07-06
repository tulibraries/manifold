require 'rails_helper'

RSpec.describe "persons/show.html.erb", type: :view do
  let (:building) { FactoryBot.create(:building) }
  let (:space) { FactoryBot.create(:space, building: building) }
  it "displays the sample person's last name" do
    @person = FactoryBot.create(:person, buildings: [building], spaces: [space])
    render
    expect(rendered).to match /#{@person.last_name}/
  end
end
