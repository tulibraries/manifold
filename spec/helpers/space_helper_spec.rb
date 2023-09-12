# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpacesHelper, type: :helper do
  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building:) }
  let(:space_without_phone) { FactoryBot.create(:space, phone_number: nil, building:) }

  describe "get_phone" do
    it "formats the space defined phone number" do
      expect(helper.get_phone(space)).to eq(number_to_phone(space.phone_number, area_code: true))
    end
    it "formats the building phone if no space number" do
      expect(helper.get_phone(space_without_phone)).to eq(number_to_phone(space.building.phone_number, area_code: true))
    end
  end
end
