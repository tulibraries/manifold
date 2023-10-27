# frozen_string_literal: true

require "rails_helper"

RSpec.describe FormInfo, type: :model do
  describe "form_attributes" do
    let(:form_info) { FactoryBot.build(:form_info) }

    it "is valid with valid attribues" do
      expect(form_info).to be_valid
    end
  end

  describe "invalid form_attributes" do
    let(:form_info) { FactoryBot.build(:form_info, :no_recipient) }
    it "is not valid without a recipient" do
      expect(form_info).to_not be_valid
    end
  end
end
