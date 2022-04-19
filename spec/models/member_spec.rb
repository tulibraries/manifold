# frozen_string_literal: true

require "rails_helper"

RSpec.describe Member, type: :model do
  context "Group has person" do
    let(:building) { FactoryBot.create(:building) }
    let(:space) { FactoryBot.create(:space, building: building) }
    let(:person1) { FactoryBot.build(:person) }
    let(:person2) { FactoryBot.build(:person) }
    let(:group) { FactoryBot.create(:group, persons: [person1], space: space, chair_dept_heads: [person1]) }

    example "Create group with person" do
      expect(group.persons).to include person1
      expect(group.persons).to_not include person2
    end

    example "Assign group with different person" do
      group.persons = [person2]
      expect(group.persons).to_not include person1
      expect(group.persons).to include person2
    end
  end

  context "Person has group" do
    let(:building) { FactoryBot.create(:building) }
    let(:space) { FactoryBot.create(:space, building: building) }
    let(:person1) { FactoryBot.create(:person) }
    let(:person2) { FactoryBot.create(:person) }
    let(:group) { FactoryBot.create(:group, space: space, persons: [person1], chair_dept_heads: [person1]) }

    example "Person includes a group" do
      expect(person1.groups).to include group
    end

    example "Assign a person's group" do
      expect(person2.groups).to_not include group
      person2.groups = [group]
      expect(person2.groups).to include group
    end

    example "Reassign a person's group" do
      expect(person2.groups).to_not include group
      person2.groups << group
      expect(person2.groups).to include group
    end
  end
end
