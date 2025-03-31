# frozen_string_literal: true

class SyncService::TodaysHours
  def self.call
    charles_hours = Google::SheetsConnector.call(feature: "hours", scope: "charles")
    hours_instance = Google::TodaysHours.new(hours: charles_hours)
    hours_data = hours_instance.hours
    File.open("public/cache/todays_hours", "w") { |file| file.write(hours_data.first[1]) }
  end
end
