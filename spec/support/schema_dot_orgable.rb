# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "SchemaDotOrgable" do
  let(:model) { described_class } # the class that includes the concern
  let(:factory_model) { FactoryBot.create(model.to_s.underscore.to_sym) }

  it "has defined a schema_dot_org_type method" do
    expect(factory_model).to respond_to(:schema_dot_org_type)
  end

  it "safely merges additional attributes" do
    expect { factory_model.map_to_schema_dot_org }.not_to raise_error
  end
end
