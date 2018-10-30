# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroupPolicy, type: :model do
  after(:each) do
    DatabaseCleaner.clean
  end

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, spaces: [space]) }
  let(:chair_person) { FactoryBot.create(:person, spaces: [space]) }

  context "Builindg has policy" do
    let(:policy1) { FactoryBot.create(:policy) }
    let(:policy2) { FactoryBot.create(:policy) }
    let(:group) { FactoryBot.create(:group, persons: [person], spaces: [space], chair_dept_head: chair_person, policies: [policy1]) }

    example "Create group with policy" do
      expect(group.policies).to include policy1
      expect(group.policies).to_not include policy2
    end

    example "Assign group with different policy" do
      group.policies = [policy2]
      expect(group.policies).to_not include policy1
      expect(group.policies).to include policy2
    end
  end

  context "group has a policy" do
    let(:policy1) { FactoryBot.create(:policy) }
    let(:policy2) { FactoryBot.create(:policy) }
    let(:group) { FactoryBot.create(:group, persons: [person], spaces: [space], chair_dept_head: chair_person, policies: [policy1]) }

    example "Assign a policy's group" do
      expect(group.policies).to_not include policy2
      group.policies = [policy2]
      expect(group.policies).to include policy2
    end

    example "Building has muliple policies" do
      expect(group.policies).to_not include policy2
      group.policies << policy2
      expect(group.policies).to include policy2
      expect(group.policies).to include policy1
    end
  end
end
