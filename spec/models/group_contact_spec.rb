# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroupContact, type: :model do
  context "Group has a Chair or Department Head" do
    let(:building) { FactoryBot.create(:building) }
    let(:space) { FactoryBot.create(:space, building: building) }
    let(:person1) { FactoryBot.build(:person, spaces: [space]) }
    let(:person2) { FactoryBot.build(:person, spaces: [space]) }
    let(:group) { FactoryBot.create(:group, persons: [person1], spaces: [space], chair_dept_head: person1) }
    let(:another_group) { FactoryBot.create(:group, persons: [person1], spaces: [space], chair_dept_head: person1) }

    example "Create group with chair or department head" do
      expect(group.chair_dept_head).to eq person1
      expect(group.chair_dept_head).to_not eq person2
    end

    example "Assign group with different chair dept head" do
      group.chair_dept_head = person2
      expect(group.chair_dept_head).to_not eq person1
      expect(group.chair_dept_head).to eq person2
    end

    example "Person can head more than one group" do
      expect(another_group.chair_dept_head).to eq person1
    end
  end
end
