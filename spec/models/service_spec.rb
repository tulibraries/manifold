# frozen_string_literal: true

require "rails_helper"

RSpec.describe Service, type: :model do

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
  end

  describe "multiple intended audiences" do
    example "select more than one" do
    service = FactoryBot.create(:service,
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
        service = FactoryBot.create(:service)
        expect { service.save! }.to_not raise_error
      end
    end
  end

  describe "version all fields" do
    fields = {
      title: ["Service Static", "The Text 2"],
      description: ["The best drink in existence is the Pan Galactic Gargle Blaster.", "The Text 2"],
      access_description: ["Fully accessible", "The Text 2"],
      intended_audience: [["General"], ["The Text 2"]],
      hours: ["hours", "The Text 2"]
    }

    fields.each do |k, v|
      example "#{k} changes" do
        service = FactoryBot.create(:service_static)
        service.update(k => v.last)
        service.save!
        expect(service.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  it_behaves_like "accountable"
end
