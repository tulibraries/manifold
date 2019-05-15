# frozen_string_literal: true

require "rails_helper"
require "uri"

RSpec.describe ServiceSerializer do
  let(:service) { FactoryBot.create(:service) }
  let(:serialized) { described_class.new(service) }

  it "doesn't raise an error when instantiated" do
    expect { serialized }.not_to raise_error
  end

  describe "serialized_hash" do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :service
    end

    it "has the expected attributes" do
      expect(data[:attributes].keys).to include(:title, :description, :access_description,
                                                :access_link, :service_policies, :intended_audience,
                                                :service_category, :hours, :add_to_footer, :label)
    end

    it "returns the title" do
      label = data[:attributes][:label]
      expect(label).to match(data[:attributes][:title])
    end
  end

  describe "serialized_json" do
    it "returns valid json" do
      Tempfile.open(["serialized_service-", ".json"]) do |tempfile|
        tempfile.write(serialized.to_json)
        tempfile.close
        args = %W[validate -s app/schemas/service_schema.json -d #{tempfile.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end
end
