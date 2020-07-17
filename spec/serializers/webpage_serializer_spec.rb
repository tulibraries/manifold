# frozen_string_literal: true

require "rails_helper"
require "uri"

RSpec.describe WebpageSerializer do
  let(:webpage) { FactoryBot.create(:webpage) }
  let(:serialized) { described_class.new(webpage) }

  it "doesn't raise an error when instantiated" do
    expect { serialized }.not_to raise_error
  end

  describe "serialized_hash" do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :webpage
    end

    it "has the expected attributes" do
      expect(data[:attributes].keys).to include(:title, :description, :layout, :label, :updated_at)
    end

    it "returns the title" do
      label = data[:attributes][:label]
      expect(label).to match(data[:attributes][:title])
    end
  end

  it_behaves_like "serializer"

end
