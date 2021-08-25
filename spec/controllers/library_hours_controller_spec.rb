# frozen_string_literal: true

require "rails_helper"

RSpec.describe LibraryHoursController, type: :controller do
  describe "build hours data structure" do
    let(:input) {
      [{ building: "charles", spaces: ["charles", "media"] }]
    }
    let(:output) {
      [{
        building: "charles",
        spaces: [{ slug: "media", hours: [["12/10/2018", "7am - 8pm"]] }]
      }]
    }
    let(:data_structure) {
      controller.send(:build_hours_data_structure, input)
    }

    it "returns the expected output" do
      allow(LibraryHour).to receive(:where).and_return([
        ["12/10/2018", "7am - 8pm"],
        ["12/10/2018", "7am - 8pm"],
        ["12/10/2018", "7am - 8pm"],
        ["12/10/2018", "7am - 8pm"],
        ["12/10/2018", "7am - 8pm"],
        ["12/10/2018", "7am - 8pm"],
        ["12/10/2018", "7am - 8pm"]
      ])
      expect(data_structure).to be_an Array
      expect(data_structure.first).to be_a Hash
      expect(data_structure.first).to have_key :building
      expect(data_structure.first).to have_key :spaces
      expect(data_structure.first[:building]).to be_a String
      expect(data_structure.first[:spaces].first).to be_a Hash
      expect(data_structure.first[:spaces].first).to have_key :slug
      expect(data_structure.first[:spaces].first[:slug]).to be_a String
      expect(data_structure.first[:spaces].first).to have_key :hours
      expect(data_structure.first[:spaces].first[:hours]).to be_an Array
      expect(data_structure.first[:spaces].first[:hours].first).to be_an Array
      expect(data_structure.first[:spaces].first[:hours].first.first).to be_a String
    end
  end
end
