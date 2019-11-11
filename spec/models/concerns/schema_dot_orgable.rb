# frozen_string_literal: true

require "rails_helper"

RSpec.describe SchemaDotOrgable do

  let(:base_attributes) { entity.base_attributes }
  let(:map_to_schema_dot_org) { entity.map_to_schema_dot_org }

  context "a class that correctly includes the concern" do
    let(:entity) do
      class ValidSchema
        include(SchemaDotOrgable)
        def label() "label" end
        def description() "description" end
        def schema_dot_org_type() "Valid" end
        def additional_schema_dot_org_attributes() { test: "banana" } end
      end
      ValidSchema.new
    end

    describe "base_attributes" do
      subject { base_attributes }
      it { is_expected.to include("@context" => "https://schema.org") }
      it { is_expected.to include(name: "label") }
      it { is_expected.to include("@type" => "Valid") }
    end

    describe "map_to_schema_dot_org" do
      it "includes all of the base_attributes" do
        expect(map_to_schema_dot_org).to include(base_attributes)
      end
      it "includes entity defined additional_attributes" do
        expect(map_to_schema_dot_org).to include(test: "banana")

      end
    end
  end

  context "a class that incorrectly includes the concern" do
    let(:entity) {
      class InvalidSchema
        include SchemaDotOrgable
      end
      InvalidSchema.new
    }
    describe "map_to_schema_dot_org" do
      it "returns an empty hash" do
        expect(map_to_schema_dot_org).to eql({})
      end
    end

  end
end
