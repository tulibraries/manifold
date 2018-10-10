# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpaceGroup, type: :model do
  context "Group has space" do
    let(:building) { FactoryBot.create(:building) }
    let(:space1) { FactoryBot.create(:space, building: building) }
    let(:space2) { FactoryBot.create(:space, building: building) }
    let(:person) { FactoryBot.build(:person, spaces: [space1]) }
    let(:group) { FactoryBot.create(:group, persons: [person], spaces: [space1], chair_dept_head: person) }

    example "Create group with space" do
      expect(group.spaces).to include space1
      expect(group.spaces).to_not include space2
    end

    example "Assign group with different space" do
      group.spaces = [space2]
      expect(group.spaces).to_not include space1
      expect(group.spaces).to include space2
    end
  end

  context "Space has group" do
    let(:building) { FactoryBot.create(:building) }
    let(:space1) { FactoryBot.create(:space, building: building) }
    let(:space2) { FactoryBot.create(:space, building: building) }
    let(:person) { FactoryBot.create(:person, spaces: [space1]) }
    let(:group) { FactoryBot.create(:group, spaces: [space1], persons: [person], chair_dept_head: person) }

    example "valid" do
      expect(space1.groups).to include group
    end

    example "Assign group to space" do
      expect(space2.groups).to_not include group
      space2.groups = [group]
      expect(space2.groups).to include group
    end
  end
end
