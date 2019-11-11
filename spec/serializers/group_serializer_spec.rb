# frozen_string_literal: true

require "rails_helper"
require "uri"

RSpec.describe GroupSerializer do
  let(:group) { FactoryBot.create(:group) }
  let(:serialized) { described_class.new(group) }

  it "doesn't raise an error when instantiated" do
    expect { serialized }.not_to raise_error
  end

  describe "serialized_hash" do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :group
    end

    it "has the expected attributes" do
      expect(data[:attributes].keys).to include(:name, :description, :group_type, :external,
                                                :label, :updated_at)
    end

    it "returns the name" do
      label = data[:attributes][:label]
      expect(label).to match(data[:attributes][:name])
    end
  end

  describe "serialized_json" do
    it "validates against the schema" do
      pending "Need to find a better schema json ruby processor. Current one doesn't support json schema v0.7"
      schema = open(Rails.root.join("app", "schemas", "group_schema.json")).read
      expect(JSON::Validator.validate(schema, serialized.serialized_json)).to be true
    end
  end
end
