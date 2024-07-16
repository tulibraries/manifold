# frozen_string_literal: true

require "rails_helper"
require "vcr"

RSpec.describe Google::TodaysHours, type: :component do

  let(:hours) {
    VCR.use_cassette("hours",) do
      Google::SheetsConnector.call(feature: "hours", scope: "charles")
    end
  }

  let(:todays_hours) {
    VCR.use_cassette("todays_hours") do
      Google::TodaysHours.new(hours:)
    end
  }

  describe "loads data" do
    it "renders results for scoped pages" do
      expect todays_hours.instance_variable_get(:@hours).size == 1
    end
  end
end
