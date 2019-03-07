# frozen_string_literal: true

require "rails_helper"
require "uri"

RSpec.describe BuildingSerializer do
  let(:building) { FactoryBot.create(:building) }
  let(:serialized) { described_class.new(building) }

  it "doesn't raise an error when instantiated" do
    expect { serialized }.not_to raise_error
  end

  describe "serialized_hash" do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :building
    end

    it "has the expected attributes" do
      expect(data[:attributes].keys).to include(:name, :address1, :address2, :temple_building_code, :coordinates, :google_id, :campus, :phone_number, :description)
    end

    it "has a link to the object" do
      expect(data[:links][:self]).to eql Rails.application.routes.url_helpers.url_for(building)
    end

    describe "building with photo" do
      let (:building) { FactoryBot.create(:building, :with_photo) }

      it "has the photo and thumbnail attributes" do
        expect(data[:attributes].keys).to include(:photo, :thumbnail_photo)
      end

      describe "photo attribute" do
        it "returns an valid url" do
          photo_url = data[:attributes][:photo]
          expect(photo_url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]).to be_truthy
        end
      end

      describe "thumbnail_photo attribute" do
        it "returns an valid url" do
          photo_url = data[:attributes][:thumbnail_photo]
          expect(photo_url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]).to be_truthy
        end
      end
    end
  end

  describe "serialized_json" do
    it "validates against the schema" do
      pending "Need to find a better schema json ruby processor. Current one doesn't support json schema v0.7"
      schema = open(Rails.root.join("app", "schemas", "building_schema.json")).read
      expect(JSON::Validator.validate(schema, serialized.serialized_json)).to be true
    end
  end
end
