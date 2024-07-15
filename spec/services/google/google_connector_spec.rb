# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe Google::SheetsConnector, type: :service do
  let(:hours) {
    VCR.use_cassette("hours", match_requests_on: [:method, :without_api_key]) do
      Google::SheetsConnector.call(feature: "hours")
    end
  }

  context "Retrieves hours data from API" do
    it "gets all hours" do
      expect(hours.values.size).to be > 0
    end
  end

end