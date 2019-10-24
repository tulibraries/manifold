# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventHelper, type: :helper do
  describe "Get Building Name" do
    context "receives string with translation" do
      it "renders the translation" do
        expect(helper.get_bldg_name("Sullivan Hall")).to include("Sullivan Hall - Blockson Collection")
      end
    end
    context "receives string without translation" do
      it "renders the default" do
        expect(helper.get_bldg_name("Kahn Hall")).to eq("Kahn Hall")
      end
    end
    context "receives nil" do
      it "skips the render which would throw an error" do
        expect(helper.get_bldg_name(nil)).to be nil
      end
    end
  end
end
