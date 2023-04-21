# frozen_string_literal: true

# We can't test base field directly, so we'll test our
# monkey patch on a field that inherits from it
require "rails_helper"
require "spec_helper"
require "administrate/field/string"

RSpec.describe Administrate::Field::String do
  let(:field) { Administrate::Field::String.new(:string, "hello", :new, (options || {})) }

  describe "#html_attributes" do
    context "html_attributes option is passed" do
      let(:options) { { html_attributes: { foo: "bar" } } }
      it "returns the expected value" do
        expect(field.html_attributes).to eql(foo: "bar")
      end
    end

    context "html_attributes option is not passed" do
      let(:options) { {} }
      it "returns the expected value" do
        expect(field.html_attributes).to eql({})
      end
    end
  end

  describe "#public_options" do
    let(:options) { { foo: "bar" } }
    it "returns the expected value" do
      expect(field.public_options).to eql(foo: "bar")
    end
  end

  describe "#required?" do
    context "resource class validates for presence" do
      let(:resource) { mock_model ValidateTrue }
      let(:options) { { resource: } }
      it "is true" do
        expect(field.required?).to be true
      end
    end

    context "required option passed is false" do
      let(:resource) { mock_model ValidateFalse }
      let(:options) { { resource: } }
      it "is false" do
        expect(field.required?).to be false
      end
    end

    context "required option is not passed" do
      let(:resource) { mock_model ValidateMissing }
      let(:options) { { resource: } }
      it "is false" do
        expect(field.required?).to be false
      end
    end
  end
end

class ValidateTrue < ApplicationRecord
  validates :string, presence: true
end

class ValidateFalse < ApplicationRecord
  validates :string, presence: false
end

class ValidateMissing < ApplicationRecord
end
