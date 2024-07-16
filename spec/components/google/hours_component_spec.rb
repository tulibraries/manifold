# frozen_string_literal: true

require "rails_helper"
require "vcr"

RSpec.describe Google::HoursComponent, type: :component do

  let(:hours) {
    VCR.use_cassette("hours") do
      Google::SheetsConnector.call(feature: "hours")
    end
  }

  let(:todays_hours) {
    VCR.use_cassette("todays_hours") do
      Google::SheetsConnector.call(feature: "hours", scope: "charles")
    end
  }

  let(:weekly_hours) {
    VCR.use_cassette("weekly_hours") do
      Google::SheetsConnector.call(feature: "hours", scope: "scrc")
    end
  }

  describe "loads data" do
    it "renders results for hours page" do
      expect(hours.values.size > 0).to be_truthy
    end
    it "renders daily results for scoped pages" do
      expect(todays_hours.value_ranges[0].values.size > 0).to be_truthy
    end
    it "renders weekly results for scoped pages" do
      expect(weekly_hours.value_ranges[0].values.size > 0).to be_truthy
    end
  end
end
