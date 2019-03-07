# frozen_string_literal: true

require "rails_helper"
require "uri"

RSpec.describe EventSerializer do
  let(:event) { FactoryBot.create(:event) }
  let(:serialized) { described_class.new(event) }

  it "doesn't raise an error when instantiated" do
    expect { serialized }.not_to raise_error
  end

  describe "serialized_hash" do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :event
    end

    it "has a link to the object" do
      expect(data[:links][:self]).to eql Rails.application.routes.url_helpers.url_for(event)
    end

    describe "event with image" do
      let (:event) { FactoryBot.create(:event, :with_image) }

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
    end
  end

  describe "serialized_json" do
    it "validates against the schema" do
      pending "Need to find a better schema json ruby processor. Current one doesn't support json schema v0.7"
      schema = open(Rails.root.join("app", "schemas", "event_schema.json")).read
      expect(JSON::Validator.validate(schema, serialized.serialized_json)).to be true
    end
  end
end
