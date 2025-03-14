# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SyncService::TodaysHours", type: :request, vcr: { cassette_name: "todays_hours" } do
  it "fetches and writes today's hours to a file" do
    SyncService::TodaysHours.call
    expect(File.read("public/cache/todays_hours")).to include("8:00 am - 8:00 pm")
  end
end
