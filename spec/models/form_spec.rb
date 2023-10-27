# frozen_string_literal: true

require "rails_helper"

RSpec.describe Form, type: :model do
  describe "form_attributes" do
    let(:form) { FactoryBot.build(:form) }

    it "is valid with valid attribues" do
      expect(form).to be_valid
    end
  end

  describe "#default_from_name" do
    let(:form) { FactoryBot.build(:form, :no_name) }
    it "supplies a default name" do
      expect(form.default_from_name).to eq("Temple University Libraries")
    end
  end

  describe "#default_from_name" do
    let(:form) { FactoryBot.build(:form, :no_email) }
    it "supplies a default name" do
      expect(form.default_from_email).to eq("templelibraries@gmail.com")
    end
  end

  describe "#headers" do
    let(:form) { FactoryBot.build(:form) }
    it "generates email headers with cc" do
      expect(form.headers).to include(cc: "form-email")
    end
  end
end
