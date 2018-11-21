# frozen_string_literal: true

require "rails_helper"

RSpec.describe "persons/show.html.erb", type: :view do
  let (:space) { FactoryBot.create(:space) }
  it "displays the sample person's last name" do
    @building = space.building
    @person = FactoryBot.create(:person, spaces: [space])
    render
    expect(rendered).to match /#{@person.last_name}/
  end
end
