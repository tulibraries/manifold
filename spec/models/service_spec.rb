# frozen_string_literal: true

require "rails_helper"

RSpec.describe Service, type: :model do
  after(:each) do
    DatabaseCleaner.clean
  end

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, spaces: [space]) }
  let(:group) { FactoryBot.create(:group, persons: [person], space: space, chair_dept_heads: [person]) }

  describe "Required attributes" do
    example "Missing title" do
      service = FactoryBot.build(:service, title: "")
      expect { service.save! }.to raise_error(/Title can't be blank/)
    end

    example "Missing description" do
      service = FactoryBot.build(:service, description: "")
      expect { service.save! }.to raise_error(/Description can't be blank/)
    end

    example "Missing intended audience" do
      service = FactoryBot.build(:service, intended_audience: "")
      expect { service.save! }.to raise_error(/Intended audience can't be blank/)
    end

    example "Missing service category" do
      service = FactoryBot.build(:service, service_category: "")
      expect { service.save! }.to raise_error(/Service category can't be blank/)
    end
  end

  describe "multiple intended audiences" do
    example "select more than one" do
      service = FactoryBot.create(:service,
        related_groups: [group],
        intended_audience: [
          Rails.configuration.audience_types.first,
          Rails.configuration.audience_types.last])
      expect(service.intended_audience).to include(Rails.configuration.audience_types.first)
      expect(service.intended_audience).to include(Rails.configuration.audience_types.last)
    end
    example "audience doesn't exist" do
      skip "behavior is TBD"
    end
  end

  describe "associated class" do
    context "Space" do
      example "attach space" do
        service = FactoryBot.create(:service, related_spaces: [space], related_groups: [group])
        expect(service.related_spaces.first.name).to match(/#{Space.first.name}/)
      end
      example "no space" do
        service = FactoryBot.create(:service, related_groups: [group])
        expect { service.save! }.to_not raise_error
      end
    end
    context "Group" do
      let(:person) { FactoryBot.build(:person, spaces: [space]) }
      let(:group) { FactoryBot.create(:group, persons: [person], space: space, chair_dept_heads: [person]) }
      example "attach group" do
        service = FactoryBot.create(:service, related_groups: [group])
        expect(service.related_groups.first.name).to match(/#{Group.first.name}/)
      end
      example "not present" do
        service = FactoryBot.build(:service)
        expect { service.save! }.to raise_error(/Related groups #{I18n.t('errors.messages.blank')}/)
      end
    end
    context "Policy" do
      skip "TBD"
    end
  end
end
