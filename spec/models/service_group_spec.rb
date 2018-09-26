require 'rails_helper'

RSpec.describe ServiceGroup, type: :model do
  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, spaces: [space]) }
  let(:group1) { FactoryBot.create(:group, persons: [person], spaces: [space], chair_dept_head: person) }
  let(:group2) { FactoryBot.create(:group, persons: [person], spaces: [space], chair_dept_head: person) }
  context "Service has space" do
    let(:service) { FactoryBot.build(:service, related_groups: [group1]) }

    example "Create service with group" do
      expect(service.related_groups).to include group1
      expect(service.related_groups).to_not include group2
    end

    example "Assign group with different service" do
      service.related_groups = [group2]
      expect(service.related_groups).to_not include group1
      expect(service.related_groups).to include group2
    end
  end

  context "Group has service" do
    let(:building) { FactoryBot.create(:building) }
    let(:space) { FactoryBot.create(:space, building: building) }
    let(:service) { FactoryBot.create(:service, related_groups: [group1]) }

    example "Service assigned to group on service creation" do
      expect(group1.related_services).to include service
    end

    example "Assign space to group" do
      expect(group2.related_services).to_not include service
      group2.related_services = [service]
      expect(group2.related_services).to include service
    end
  end
end
