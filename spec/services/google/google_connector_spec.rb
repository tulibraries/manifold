# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe Google::SheetsConnector, type: :service do
  let(:hours) {
    VCR.use_cassette("hours", match_requests_on: [:method, :without_api_key]) do
      Google::SheetsConnector.call(feature: "hours")
    end
  }
  let(:todays_hours) {
    VCR.use_cassette("todays_hours", match_requests_on: [:method, :without_api_key]) do
      Google::SheetsConnector.call(feature: "hours", scope: "charles")
    end
  }

  context "Retrieves hours data from API" do
    it "gets all hours" do
      expect(hours.values.size).to be > 0
    end
    it "gets location specific hours" do
      expect(todays_hours.value_ranges[0].values.size).to be > 0
    end
  end

end