# frozen_string_literal: true

require "rails_helper"
require "vcr"

RSpec.describe Google::WeeklyHours, type: :component do
  let(:hours) {
    VCR.use_cassette("hours", match_requests_on: [:method, :without_api_key]) do
      Google::SheetsConnector.call(feature: "hours", scope: "scrc")
    end
  }

  let(:weekly_hours) {
    VCR.use_cassette("weekly_hours", match_requests_on: [:method, :without_api_key]) do
      Google::WeeklyHours.new(hours:, location: "scrc")
    end
  }

  describe "loads data" do
    it "renders results for scoped pages" do
      expect weekly_hours.instance_variable_get(:@weekly_hours).size == 6
    end
  end
end
