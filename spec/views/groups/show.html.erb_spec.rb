# frozen_string_literal: true

require "rails_helper"

RSpec.describe "groups/show.html.erb", type: :view do
  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.create(:person, spaces: [space]) }
  # let(:chair_person) { FactoryBot.create(:person, spaces: [space]) }

  it "displays the sample group name" do
    @group = FactoryBot.create(:group, spaces: [space], chair_dept_head: person)
    render
    expect(rendered).to match /#{@group.name}/
  end

  it "displays the person" do
    @group = FactoryBot.create(:group, persons: [person], spaces: [space], chair_dept_head: person)
    render
    expect(rendered).to match /#{Person.last.last_name}/
  end

  it "displays the space" do
    @group = FactoryBot.create(:group, spaces: [space], chair_dept_head: person)
    render
    expect(rendered).to match /#{Space.last.name}/
  end
end
