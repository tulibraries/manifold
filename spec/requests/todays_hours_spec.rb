# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SyncService::TodaysHours", type: :request do
  it "fetches and writes today's hours to a file" do
    # Mock the Google Sheets connector to return mock data
    mock_charles_hours = [["some_key", "9am - 5pm"]]
    allow(Google::SheetsConnector).to receive(:call)
      .with(feature: "hours", scope: "charles")
      .and_return(mock_charles_hours)

    # Mock the TodaysHours class to return the expected format
    mock_hours_instance = double("TodaysHours")
    allow(Google::TodaysHours).to receive(:new)
      .with(hours: mock_charles_hours)
      .and_return(mock_hours_instance)
    allow(mock_hours_instance).to receive(:hours).and_return([["some_key", "9am - 5pm"]])

    SyncService::TodaysHours.call

    expect(File.read("public/cache/todays_hours")).to include("9am - 5pm")
  end
end
