# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroupContact, type: :model do
  context "Group has a Chair or Department Head" do
    let(:building) { FactoryBot.create(:building) }
    let(:space) { FactoryBot.create(:space, building:) }
    let(:person1) { FactoryBot.create(:person, buildings: [building]) }
    let(:person2) { FactoryBot.create(:person, buildings: [building]) }
    let(:group) { FactoryBot.create(:group, persons: [person1], space:, chair_dept_heads: [person1]) }
    let(:another_group) { FactoryBot.create(:group, persons: [person1], space:, chair_dept_heads: [person1]) }

    example "Create group with chair or department head" do
      expect(group.chair_dept_heads).to include person1
      expect(group.chair_dept_heads).to_not include person2
    end

    example "Assign group with different chair dept head" do
      group.chair_dept_heads = [person2]
      expect(group.chair_dept_heads).to_not include person1
      expect(group.chair_dept_heads).to include person2
    end

    example "Person can head more than one group" do
      expect(another_group.chair_dept_heads).to include person1
    end
  end
end
