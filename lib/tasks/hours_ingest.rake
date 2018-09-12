require 'google/apis/sheets_v4'

namespace :db do
    namespace :update do

      desc 'Updates from Gsheets'
      task :hours => :environment do |t, args|

        # Initialize the API
        service = Google::Apis::SheetsV4::SheetsService.new
        service.key = ENV['GOOGLE_SHEETS_API_KEY']

        spreadsheet_id = '1nZkmNzNwMsVlTa4sg3V1M1KOAvXcoyexLkeqTzqV_gs'

        headers = 'Sheet1!A1:L1'
        date_coordinates = 'Sheet1!A2:A'
        date_response = service.get_spreadsheet_values(spreadsheet_id, date_coordinates)
        dates = date_response.values.flatten

        locations = [
                      {coordinates: 'Sheet1!B2:B', slug: 'paley'},
                      {coordinates: 'Sheet1!C2:C', slug: 'media'},
                      {coordinates: 'Sheet1!D2:D', slug: 'doc_del'},
                      {coordinates: 'Sheet1!E2:E', slug: 'ref_desk'},
                      {coordinates: 'Sheet1!F2:F', slug: 'v_ref'},
                      {coordinates: 'Sheet1!G2:G', slug: 'thinktank'},
                      {coordinates: 'Sheet1!H2:H', slug: 'scrc'},
                      {coordinates: 'Sheet1!I2:I', slug: 'blockson'},
                      {coordinates: 'Sheet1!J2:J', slug: 'dsc'},
                      {coordinates: 'Sheet1!K2:K', slug: 'ambler'},
                      {coordinates: 'Sheet1!L2:L', slug: 'guest_computers'}
                    ]

        locations.each do |location|
          dates.zip(service.get_spreadsheet_values(spreadsheet_id, location[:coordinates]).values.map { |a| a == [] ? nil : a }.flatten).each do |hours|
          # flattening removes empty arrays, and subsequent rows are thus off by one. changing empty array to nil gets around this

            if hours.last.nil?
              time = "TBD"
            else 
              time = hours.last
            end
            mid = LibraryHours.find_by(location_id: location[:slug], date: DateTime.parse(hours.first))
            if mid
              mid.hours = time
              if mid.hours_changed?
                mid.save 
              end
            else 
              LibraryHours.create!(location_id: location[:slug],
                                    date: hours.first.to_s.to_date,
                                    hours: time )
            end

        end
      end

    end # hours
  end # update
end # db
