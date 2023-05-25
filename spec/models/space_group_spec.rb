# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpaceGroup, type: :model do
  context "Group has space" do
    let(:building) { FactoryBot.create(:building) }
    let(:space1) { FactoryBot.create(:space, building:) }
    let(:space2) { FactoryBot.create(:space, building:) }
    let(:person) { FactoryBot.build(:person) }
    let(:group) { FactoryBot.create(:group, persons: [person], space: space1, chair_dept_heads: [person]) }

    example "Create group with space" do
      expect(group.space.name).to match(/#{space1.name}/)
      # expect(group.space).to include space1
      # expect(group.space).to_not include space2
    end

    example "Assign group with different space" do
      group.space = space2
      expect(group.space.name).to match(/#{space2.name}/)
      # expect(group.space).to_not include space1
      # expect(group.space).to include space2
    end
  end

  context "Space has group" do
    let(:building) { FactoryBot.create(:building) }
    let(:space1) { FactoryBot.create(:space, building:) }
    let(:space2) { FactoryBot.create(:space, building:) }
    let(:person) { FactoryBot.create(:person) }
    let(:group) { FactoryBot.create(:group, space: space1, persons: [person], chair_dept_heads: [person]) }

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
