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
      expect(data[:attributes].keys).to include(:name, :address1, :city, :state, :zipcode, :coordinates, :google_id,
                                                :phone_number, :label, :updated_at)
    end

    it "has a link to the object" do
      expect(data[:links][:self]).to eql Rails.application.routes.url_helpers.url_for(building)
    end

    describe "generates label from name" do
      let (:building) { FactoryBot.create(:building) }

      describe "label attribute" do
        it "returns the name" do
          label = data[:attributes][:label]
          expect(label).to match(data[:attributes][:name])
        end
      end
    end
  end

  it_behaves_like "serializer"

end
