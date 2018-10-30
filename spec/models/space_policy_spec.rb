# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpacePolicy, type: :model do
  after(:each) do
    DatabaseCleaner.clean
  end

  context "Builindg has policy" do
    let(:policy1) { FactoryBot.create(:policy) }
    let(:policy2) { FactoryBot.create(:policy) }
    let(:space) { FactoryBot.build(:space_with_building, policies: [policy1]) }

    example "Create space with policy" do
      expect(space.policies).to include policy1
      expect(space.policies).to_not include policy2
    end

    example "Assign space with different policy" do
      space.policies = [policy2]
      expect(space.policies).to_not include policy1
      expect(space.policies).to include policy2
    end
  end

  context "space has a policy" do
    let(:policy1) { FactoryBot.create(:policy) }
    let(:policy2) { FactoryBot.create(:policy) }
    let(:space) { FactoryBot.create(:space_with_building, policies: [policy1]) }

    example "Assign a policy's space" do
      expect(space.policies).to_not include policy2
      space.policies = [policy2]
      expect(space.policies).to include policy2
    end

    example "Building has muliple policies" do
      expect(space.policies).to_not include policy2
      space.policies << policy2
      expect(space.policies).to include policy2
      expect(space.policies).to include policy1
    end
  end
end
