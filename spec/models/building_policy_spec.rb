# frozen_string_literal: true

require "rails_helper"

RSpec.describe BuildingPolicy, type: :model do
  after(:each) do
    DatabaseCleaner.clean
  end

  context "Builindg has policy" do
    let(:policy1) { FactoryBot.create(:policy) }
    let(:policy2) { FactoryBot.create(:policy) }
    let(:building) { FactoryBot.create(:building, policies: [policy1]) }

    example "Create building with policy" do
      expect(building.policies).to include policy1
      expect(building.policies).to_not include policy2
    end

    example "Assign building with different policy" do
      building.policies = [policy2]
      expect(building.policies).to_not include policy1
      expect(building.policies).to include policy2
    end
  end

  context "building has a policy" do
    let(:policy1) { FactoryBot.create(:policy) }
    let(:policy2) { FactoryBot.create(:policy) }
    let(:building) { FactoryBot.create(:building, policies: [policy1]) }

    example "Assign a policy's building" do
      expect(building.policies).to_not include policy2
      building.policies = [policy2]
      expect(building.policies).to include policy2
    end

    example "Building has muliple policies" do
      expect(building.policies).to_not include policy2
      building.policies << policy2
      expect(building.policies).to include policy2
      expect(building.policies).to include policy1
    end
  end
end
