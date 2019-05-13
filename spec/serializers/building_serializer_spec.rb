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
      expect(data[:attributes].keys).to include(:name, :address1, :address2, :temple_building_code, :coordinates, :google_id, :campus, :phone_number, :description, :label)
    end

    it "has a link to the object" do
      expect(data[:links][:self]).to eql Rails.application.routes.url_helpers.url_for(building)
    end

    describe "building with image" do
      let (:building) { FactoryBot.create(:building, :with_image) }

      it "has the image and thumbnail attributes" do
        expect(data[:attributes].keys).to include(:image, :thumbnail_image)
      end

      describe "image attribute" do
        it "returns an valid url" do
          image_url = data[:attributes][:image]
          expect(image_url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]).to be_truthy
        end
      end

      describe "thumbnail_image attribute" do
        it "returns an valid url" do
          image_url = data[:attributes][:thumbnail_image]
          expect(image_url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]).to be_truthy
        end
      end

      describe "label attribute" do
        it "returns the name" do
          label = data[:attributes][:label]
          expect(label).to match(data[:attributes][:name])
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
