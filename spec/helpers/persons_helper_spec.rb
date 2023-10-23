# frozen_string_literal: true

require "rails_helper"

RSpec.describe PersonsHelper, type: :helper do
  describe "Get location name" do
    let(:building) { FactoryBot.create(:building) }

    it "returns person's location" do
      expect(helper.get_loc_name(building.id)).to eql building.name
    end
  end

  describe "Get department name" do
    let(:group) { FactoryBot.create(:group) }

    it "returns department" do
      expect(helper.get_dept_name(group.id)).to eql group.name
    end
  end

end
