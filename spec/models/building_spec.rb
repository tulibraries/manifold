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

    context "External Link" do
      let(:external_link) { FactoryBot.create(:external_link) }
      example "attach external link" do
        building = FactoryBot.create(:building, external_link: external_link)
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

  describe "Makes Linked Data hash" do
    let(:city) { "Philadelphia" }
    let(:state) { "PA" }
    let(:zip_code) { "19122" }
    let(:building) { FactoryBot.create(:building, :with_image, address2: "#{city}, #{state}, #{zip_code}") }
    let(:building_no_image) { FactoryBot.create(:building) }

    describe "Linked data hash" do
      subject { building.map_to_schema_dot_org }

      it { is_expected.to include("name" => building[:name]) }
      it { is_expected.to include("description" => building[:description]) }
      it { is_expected.to include("location") }

      describe "location" do
        subject { building.map_to_schema_dot_org["location"] }

        it { is_expected.to include("@type" => "https://schema.org/Place") }
        it { is_expected.to include("address") }

        describe "address" do
          subject { building.map_to_schema_dot_org["location"]["address"] }

          it { is_expected.to include("@type" => "https://schema.org/PostalAddress") }
          it { is_expected.to include("streetAddress" => building.address1) }
          it { is_expected.to include("addressLocality" => a_string_including(city)) }
          it { is_expected.to include("addressLocality" => a_string_including(state)) }
          it { is_expected.to include("addressLocality" => a_string_including(zip_code)) }
        end
      end

      it { is_expected.to include("telephone" => building[:phone_number]) }
      it { is_expected.to include("email" => building[:email]) }
      it { is_expected.to include("image" => building.index_image_url) }
      xit { is_expected.to include("hours" => building[:hours]) }
      it { is_expected.to include("geo" => building[:coordinates]) }
      it { is_expected.to include("googleId" => building[:google_id]) }

      context "building without an image" do
        it "does not include an image tag" do
          expect(building_no_image.map_to_schema_dot_org.keys).not_to include("image")
        end
      end
    end
  end

  it_behaves_like "categorizable"
  it_behaves_like "imageable"
  it_behaves_like "SchemaDotOrgable"
end
