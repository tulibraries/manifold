# frozen_string_literal: true

require "rails_helper"

RSpec.describe "groups/show.html.erb", type: :view do
  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.create(:person, spaces: [space]) }
  let(:chair_person) { FactoryBot.create(:person, spaces: [space]) }

  it "displays the sample group name" do
    @group = FactoryBot.create(:group, space: space, chair_dept_heads: [chair_person])
    render
    expect(rendered).to match /#{@group.name}/
  end

  it "displays the person" do
    @group = FactoryBot.create(:group, persons: [person], space: space, chair_dept_heads: [chair_person])
    render
    expect(rendered).to match /#{Person.first.last_name}/
  end

  it "displays the space" do
    @group = FactoryBot.create(:group, space: space, chair_dept_heads: [chair_person])
    render
    expect(rendered).to match /#{Space.first.name}/
  end
end
