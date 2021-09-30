# frozen_string_literal: true

require "rails_helper"
require "uri"

RSpec.describe SpaceSerializer do
  let(:space) { FactoryBot.create(:space) }
  let(:serialized) { described_class.new(space) }

  it "doesn't raise an error when instantiated" do
    expect { serialized }.not_to raise_error
  end

  describe "serialized_hash" do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :space
    end

    it "has the expected attributes" do
      expect(data[:attributes].keys).to include(:name, :description, :hours, :phone_number,
                                                :email, :label, :updated_at)
    end

    it "returns the name" do
      label = data[:attributes][:label]
      expect(label).to match(data[:attributes][:name])
    end
  end

  it_behaves_like "serializer"

end
