# frozen_string_literal: true

require "rails_helper"
require "uri"

RSpec.describe AlertSerializer do
  let(:alert) { FactoryBot.create(:alert) }
  let(:serialized) { described_class.new(alert) }

  it "doesn't raise an error when instantiated" do
    expect { serialized }.not_to raise_error
  end

  describe "serialized_hash" do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :alert
    end

    it "has the expected attributes" do
      expect(data[:attributes].keys).to include(:scroll_text, :description, :link, :published)
    end

    it "returns the scroll_text" do
      scroll_text = data[:attributes][:scroll_text]
      expect(scroll_text).to match(data[:attributes][:scroll_text])
    end
  end

  it_behaves_like "serializer"

end
