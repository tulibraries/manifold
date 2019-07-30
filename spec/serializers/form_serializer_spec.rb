# frozen_string_literal: true

require "rails_helper"

RSpec.describe FormSerializer do
  let(:form) {   OpenStruct.new(
    id: "a-form",
    label: "a form for all things",
    link: "http://test.host/forms/a-form",
    updated_at: DateTime.new(0)
    )
  }
  let(:serialized) { described_class.new(form) }

  it "doesn't raise an error when instantiated" do
    expect { serialized }.not_to raise_error
  end

  describe "serialized_hash" do
    let(:sh) { serialized.serializable_hash }
    let(:data) { sh[:data] }

    it "has the expected type" do
      expect(data[:type]).to eql :form
    end

    it "has the expected attributes" do
      expect(data[:attributes].keys).to include(:label, :updated_at)
    end

  end
end
