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

  describe "enable form" do
    let(:form_info) { FactoryBot.build(:form_info) }
    it "is is enabled by default" do
      expect(form_info.enabled).to be
    end
  end

  describe "disaable form" do
    let(:form_info) { FactoryBot.build(:form_info, :disabled) }
    it "is is enabled by default" do
      expect(form_info.enabled).to_not be
    end
  end

  describe "for index scope" do
    not_grouped = FormInfo.create!(title: "Not grouped", slug: "not-grouped", recipients: ["library@temple.edu"], grouping: nil)
    grouped = FormInfo.create!(title: "Grouped", slug: "grouped", recipients: ["library@temple.edu"], grouping: "Administrative Services")

    it "includes forms wth grouping" do
      expect(FormInfo.for_index).to include(grouped)
    end
    it "does not include forms without grouping" do
      expect(FormInfo.for_index).to_not include(not_grouped)
    end
  end
end
