# frozen_string_literal: true

require "rails_helper"
require "uri"

RSpec.describe FindingAidSerializer do
  let(:finding_aid) { FactoryBot.create(:finding_aid) }
  let(:serialized) { described_class.new(finding_aid) }

  it "doesn't raise an error when instantiated" do
    expect { serialized }.not_to raise_error
  end

  describe "serialized_hash" do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :finding_aid
    end

    it "has the expected attributes" do
      expect(data[:attributes].keys).to include(:name, :description, :subject, :content_link,
                                                :identifier, :drupal_id, :label)
    end

    it "returns the name" do
      label = data[:attributes][:label]
      expect(label).to match(data[:attributes][:name])
    end
  end

  describe "serialized_json" do
    it "returns valid json" do
      Tempfile.open(["serialized_finding_aid-", ".json"]) do |tempfile|
        tempfile.write(serialized.to_json)
        tempfile.close
        args = %W[validate -s app/schemas/finding_aid_schema.json -d #{tempfile.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end
end
