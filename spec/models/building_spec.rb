# frozen_string_literal: true

require "rails_helper"

RSpec.describe Building, type: :model do

  context "Required Fields" do
    required_fields = [
     "name",
     "address1",
     "city",
     "state",
     "zipcode",
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

    context "External Link" do
      let(:external_link) { FactoryBot.create(:external_link) }
      example "attach external link" do
        building = FactoryBot.create(:building, external_link:)
        expect(building.external_link.title).to match(/#{external_link.title}/)
        expect(building.external_link.link).to match(/#{external_link.link}/)
      end
      example "no external" do
        building = FactoryBot.create(:building)
        expect { building.save! }.to_not raise_error
      end
    end
  end

  describe "version all fields" do
    fields = {
      name: ["The Text 1", "The Text 2"],
      address1: ["The Text 1", "The Text 2"],
      coordinates: ["The Text 1", "The Text 2"],
      phone_number: ["2155551212", "2155551234"],
      email: ["The Text 1", "The Text 2"],
      google_id: ["The Text 1", "The Text 2"]
    }

    fields.each do |k, v|
      example "#{k} changes" do
        skip("description not versionable") if k == :description
        building = FactoryBot.create(:building, k => v.first)
        building.update(k => v.last)
        building.save!
        expect(building.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  describe "Makes Linked Data hash" do
    let(:building) { FactoryBot.create(:building, description: "building description", hours: "paley") }

    describe "Linked data hash" do
      subject { building.map_to_schema_dot_org }

      it { is_expected.to include("name" => building.name) }
      it { is_expected.to include("description" => building.description.to_plain_text) }
      it { is_expected.to include("address") }
      it { is_expected.to include("telephone" => building.phone_number) }
      it { is_expected.to include("email" => building.email) }
      it { is_expected.to include("geo" => building.coordinates) }
      it { is_expected.to include("googleId" => building.google_id) }

      describe "address" do
        subject { building.map_to_schema_dot_org["address"] }
        it { is_expected.to include("@type" => "https://schema.org/PostalAddress") }
        it { is_expected.to include("addressLocality" => building.city) }
        it { is_expected.to include("addressRegion" => building.state) }
        it { is_expected.to include("postalCode" => building.zipcode) }
        it { is_expected.to include("streetAddress" => building.address1) }
      end
    end
  end

  it_behaves_like "categorizable"
  it_behaves_like "SchemaDotOrgable"
end
