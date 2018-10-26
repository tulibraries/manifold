# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServiceSpace, type: :model do
  context "Service has space" do
    let(:building) { FactoryBot.create(:building) }
    let(:space1) { FactoryBot.create(:space, building: building) }
    let(:space2) { FactoryBot.create(:space, building: building) }
    let(:service) { FactoryBot.build(:service, related_spaces: [space1]) }

    example "Create service with space" do
      expect(service.related_spaces).to include space1
      expect(service.related_spaces).to_not include space2
    end

    example "Assign group with different space" do
      service.related_spaces = [space2]
      expect(service.related_spaces).to_not include space1
      expect(service.related_spaces).to include space2
    end
  end

  context "Space has service" do
    let(:building) { FactoryBot.create(:building) }
    let(:space1) { FactoryBot.create(:space, building: building) }
    let(:space2) { FactoryBot.create(:space, building: building) }
    let(:person) { FactoryBot.build(:person, spaces: [space1]) }
    let(:group) { FactoryBot.create(:group, persons: [person], spaces: [space1], chair_dept_heads: [person]) }
    let(:service) { FactoryBot.create(:service, related_spaces: [space1], related_groups: [group]) }

    example "Assign service to space in service creation" do
      expect(space1.related_services).to include service
    end

    example "Assign group to space" do
      expect(space2.related_services).to_not include service
      space2.related_services = [service]
      expect(space2.related_services).to include service
    end
  end
end
