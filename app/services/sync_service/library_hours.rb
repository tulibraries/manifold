# frozen_string_literal: true

require "google/apis/sheets_v4"

class SyncService::LibraryHours
  def self.call
    service = Google::Apis::SheetsV4::SheetsService.new
    service.key = Rails.configuration.google_sheets_api_key
    spreadsheet_id = Rails.configuration.hours_spreadsheet_id
    worksheet = Rails.configuration.hours_worksheet
    date_coordinates = Rails.configuration.hours_spreadsheet_date_cells
    date_response = service.get_spreadsheet_values(spreadsheet_id, date_coordinates)
    dates = date_response.values.flatten

    binding.pry

    locations = [
                  { coordinates: "#{worksheet}!B2:B", slug: "charles" },
                  { coordinates: "#{worksheet}!C2:C", slug: "service_zone" },
                  { coordinates: "#{worksheet}!D2:D", slug: "cafe" },
                  { coordinates: "#{worksheet}!E2:E", slug: "scrc" },
                  { coordinates: "#{worksheet}!F2:F", slug: "scholars_studio" },
                  { coordinates: "#{worksheet}!H2:H", slug: "ask_a_librarian" },
                  { coordinates: "#{worksheet}!I2:I", slug: "asrs" },
                  { coordinates: "#{worksheet}!J2:J", slug: "guest_computers" },
                  { coordinates: "#{worksheet}!K2:K", slug: "blockson" },
                  { coordinates: "#{worksheet}!L2:L", slug: "ambler" },
                  { coordinates: "#{worksheet}!M2:M", slug: "ginsburg" },
                  { coordinates: "#{worksheet}!N2:N", slug: "podiatry" },
                  { coordinates: "#{worksheet}!O2:O", slug: "innovation" },
                  { coordinates: "#{worksheet}!P2:P", slug: "24-7" },
                  { coordinates: "#{worksheet}!R2:R", slug: "exhibits" }
                ]

    locations.each do |location|
      dates.zip(service.get_spreadsheet_values(spreadsheet_id, location[:coordinates]).values.map {
        |a| a == [] ? nil : a }.flatten).each do |hours|
        # flattening removes empty arrays, and subsequent rows are thus off by one.
        # changing empty array to nil gets around this

        if hours.last.nil?
          time = "TBD"
        else
          time = hours.last
        end

        mid = LibraryHour.find_by(location_id: location[:slug], date: Time.zone.parse(hours.first))

        if mid
          mid.hours = time
          if mid.hours_changed?
            mid.save
          end
        else
          LibraryHour.create!(location_id: location[:slug],
                                date: hours.first.to_s.to_date,
                                hours: time)
        end
      end
    end
  end #init
end #class
