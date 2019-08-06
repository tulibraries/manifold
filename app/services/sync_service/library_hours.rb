# frozen_string_literal: true

require "google/apis/sheets_v4"

class SyncService::LibraryHours
  def self.call
    service = Google::Apis::SheetsV4::SheetsService.new
    service.key = ENV["GOOGLE_SHEETS_API_KEY"]
    spreadsheet_id = "1nZkmNzNwMsVlTa4sg3V1M1KOAvXcoyexLkeqTzqV_gs"
    headers = "Sheet2!A1:O1"
    date_coordinates = "Sheet2!A2:A"
    date_response = service.get_spreadsheet_values(spreadsheet_id, date_coordinates)
    dates = date_response.values.flatten

    locations = [
                  { coordinates: "Sheet2!B2:B", slug: "charles" },
                  { coordinates: "Sheet2!C2:C", slug: "service_zone" },
                  { coordinates: "Sheet2!D2:D", slug: "cafe" },
                  { coordinates: "Sheet2!E2:E", slug: "scrc" },
                  { coordinates: "Sheet2!F2:F", slug: "scholars_studio" },
                  { coordinates: "Sheet2!G2:G", slug: "success_center" },
                  { coordinates: "Sheet2!H2:H", slug: "ask_a_librarian" },
                  { coordinates: "Sheet2!I2:I", slug: "asrs" },
                  { coordinates: "Sheet2!J2:J", slug: "guest_computers" },
                  { coordinates: "Sheet2!K2:K", slug: "blockson" },
                  { coordinates: "Sheet2!L2:L", slug: "ambler" },
                  { coordinates: "Sheet2!M2:M", slug: "ginsburg" },
                  { coordinates: "Sheet2!N2:N", slug: "podiatry" },
                  { coordinates: "Sheet2!O2:O", slug: "innovation" },
                  { coordinates: "Sheet2!P2:P", slug: "24-7" }
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
