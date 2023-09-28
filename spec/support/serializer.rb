# frozen_string_literal: true

require "spec_helper"
require "json-schema"

RSpec.shared_examples "serializer" do
  let(:model) { described_class.to_s.split("Serializer").first.underscore.downcase.singularize.to_sym } # the class that includes the concern
  let(:factory_model) { FactoryBot.create(model) }
  let(:serialized) { described_class.new(factory_model) }

  it "returns valid json" do
    Tempfile.open(["serialized_#{model}", ".json"]) do |tempfile|
      tempfile.write(serialized.to_json)
      tempfile.close
      expect(JSON::Validator.validate!("app/schemas/#{model}_schema.json", tempfile.path)).to be
    end
  end

end
