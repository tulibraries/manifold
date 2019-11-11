# frozen_string_literal: true

require "rails_helper"

RSpec.describe Service, type: :model do

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, spaces: [space]) }
  let(:group) { FactoryBot.create(:group, persons: [person], space: space, chair_dept_heads: [person]) }
  let(:external_link) { FactoryBot.create(:external_link) }

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
      service = FactoryBot.build(:service, intended_audience: [""])
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
        expect(service.related_spaces.last.name).to match(/#{space.name}/)
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
        expect(service.related_groups.last.name).to match(/#{group.name}/)
      end
      example "not present" do
        service = FactoryBot.build(:service)
        service.related_groups.clear
        expect { service.save! }.to raise_error(/Related groups #{I18n.t('errors.messages.blank')}/)
      end
    end
    context "Policy" do
      skip "TBD"
    end
    context "External Link" do
      example "attach external link" do
        service = FactoryBot.create(:service, external_link: external_link)
        expect(service.external_link.title).to match(/#{external_link.title}/)
        expect(service.external_link.link).to match(/#{external_link.link}/)
      end
      example "no external" do
        service = FactoryBot.create(:service, related_groups: [group])
        expect { service.save! }.to_not raise_error
      end
    end
  end

  describe "version all fields" do
    fields = {
      title: ["The Text 1", "The Text 2"],
      description: ["The Text 1", "The Text 2"],
      access_description: ["The Text 1", "The Text 2"],
      access_link: ["The Text 1", "The Text 2"],
      service_policies: ["The Text 1", "The Text 2"],
      #intended_audience: ["The Text 1", "The Text 2"],
      service_category: ["The Text 1", "The Text 2"],
      hours: ["The Text 1", "The Text 2"]
    }

    fields.each do |k, v|
      example "#{k} changes" do
        service = FactoryBot.create(:service, related_groups: [group], k => v.first)
        service.update(k => v.last)
        service.save!
        expect(service.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  it_behaves_like "accountable"
  it_behaves_like "categorizable"
end
