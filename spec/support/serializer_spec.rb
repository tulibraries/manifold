# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "serializer" do
  let(:model) { described_class.to_s.split("Serializer").first.underscore.downcase.singularize.to_sym } # the class that includes the concern
  let(:factory_model) { FactoryBot.create(model) }
  let(:serialized) { described_class.new(factory_model) }

  xit "returns valid json" do
    Tempfile.open(["serialized_#{model}", ".json"]) do |tempfile|
      tempfile.write(serialized.to_json)
      tempfile.close
      args = %W[validate -s app/schemas/#{model}_schema.json -d #{tempfile.path}]
      expect(system("ajv", *args)).to be
    end
  end

end
