# frozen_string_literal: true

require "rails_helper"

RSpec.describe BuildingsHelper, type: :helper do
  describe "US phone formatting" do
    context "ten digit vs others" do
      let(:us_building) { FactoryBot.create(:building, phone_number: "1234567890") }
      let(:japan_building) { FactoryBot.create(:building, phone_number: "81 (03) 54419867") }

      it "returns us formatted phone" do
        expect(helper.phone_formatted(us_building.phone_number)).to eql "(123) 456-7890"
      end
      it "returns non-us formatted phone" do
        expect(helper.phone_formatted(japan_building.phone_number)).to eql "81 (03) 54419867"
      end
    end
  end

  describe "city state zipcode" do
    context "all fields present" do
      let(:building) { FactoryBot.create(:building) }
      it "takes all fields returns string" do
        expect(helper.formatted_address(building)).to eql "#{building.address1} #{building.city} #{building.state} #{building.zipcode}"
      end
    end
  end
end
