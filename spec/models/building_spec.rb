# frozen_string_literal: true

require "rails_helper"

RSpec.describe Building, type: :model do

  context "Required Fields" do
    required_fields = [
      "name",
      "description",
      "address1",
      "address2",
      "temple_building_code",
      "coordinates",
      "google_id",
    ]
    required_fields.each do |f|
      example "missing #{f} field" do
        building = FactoryBot.build(:building)
        building[f] = ""
        expect { building.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
      end
    end
  end

  describe "field validators" do

    let(:building) { FactoryBot.build(:building) }

    context "Phone number validation" do
      example "valid phone number" do
        building.phone_number = "2155551212"
        expect { building.save! }.to_not raise_error
      end
      example "invalid phone number" do
        building.phone_number = "215555121"
        expect { building.save! }.to raise_error(/#{I18n.t('manifold.error.invalid_phone_format')}/)
      end
      example "invalid phone number - blank " do
        building.phone_number = ""
        expect { building.save! }.to raise_error(/#{I18n.t('manifold.error.invalid_phone_format')}/)
      end
    end

    context "Policy reference" do
      example "Add building policy" do
        policy = FactoryBot.create(:policy)
        building = FactoryBot.create(:building)
        building.policies << policy
        expect(building.policies).to include(policy)
      end
    end
  end

  describe "version all fields" do
    fields = {
      name: ["The Text 1", "The Text 2"],
      description: ["The Text 1", "The Text 2"],
      address1: ["The Text 1", "The Text 2"],
      temple_building_code: ["The Text 1", "The Text 2"],
      coordinates: ["The Text 1", "The Text 2"],
      hours: ["The Text 1", "The Text 2"],
      phone_number: ["2155551212", "2155551234"],
      campus: ["The Text 1", "The Text 2"],
      email: ["The Text 1", "The Text 2"],
      google_id: ["The Text 1", "The Text 2"],
      address2: ["The Text 1", "The Text 2"],
      add_to_footer: [false, true]
    }

    fields.each do |k, v|
      example "#{k} changes" do
        building = FactoryBot.create(:building, k => v.first)
        building.update(k => v.last)
        building.save!
        expect(building.versions.last.changeset[k]).to match_array(v)
      end
    end
  end
end
