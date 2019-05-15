# frozen_string_literal: true

require "rails_helper"
require "uri"

RSpec.describe CollectionSerializer do
  let(:collection) { FactoryBot.create(:collection) }
  let(:serialized) { described_class.new(collection) }

  it "doesn't raise an error when instantiated" do
    expect { serialized }.not_to raise_error
  end

  describe "serialized_hash" do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :collection
    end

    it "has the expected attributes" do
      expect(data[:attributes].keys).to include(:name, :description, :label)
    end

    it "returns the name" do
      label = data[:attributes][:label]
      expect(label).to match(data[:attributes][:name])
    end
  end

  describe "serialized_json" do
    it "returns valid json" do
      Tempfile.open(["serialized_collection", ".json"]) do |tempfile|
        tempfile.write(serialized.to_json)
        tempfile.close
        args = %W[validate -s app/schemas/collection_schema.json -d #{tempfile.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end
end
