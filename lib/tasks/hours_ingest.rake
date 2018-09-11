require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

namespace :db do
    namespace :update do

      desc 'Updates from Gsheets'
      task :hours => :environment do |t, args|

        # Initialize the API
        service = Google::Apis::SheetsV4::SheetsService.new
        service.key = ENV['GOOGLE_SHEETS_API_KEY']

        spreadsheet_id = '1nZkmNzNwMsVlTa4sg3V1M1KOAvXcoyexLkeqTzqV_gs'

        # response = service.batch_get_spreadsheet_values(spreadsheet_id)
        # hoursdata = response.to_json

        headers = 'Sheet1!A1:L1'
        data = 'Sheet1!A2:L'
        dates = 'Sheet1!A2:A'
        paley = 'Sheet1!B2:B'
        media = 'Sheet1!C2:C'
        doc_del = 'Sheet1!D2:D'
        ref_desk = 'Sheet1!E2:E'
        v_ref = 'Sheet1!F2:F'
        thinktank = 'Sheet1!G2:G'
        scrc = 'Sheet1!H2:H'
        blockson = 'Sheet1!I2:I'
        dsc = 'Sheet1!J2:J'
        ambler = 'Sheet1!K2:K'
        guest_computers = 'Sheet1!L2:L'

        locations = service.get_spreadsheet_values(spreadsheet_id, headers)
        dates = service.get_spreadsheet_values(spreadsheet_id, dates)
        paley_hours = service.get_spreadsheet_values(spreadsheet_id, paley)
        media_hours = service.get_spreadsheet_values(spreadsheet_id, media)
        doc_del_hours = service.get_spreadsheet_values(spreadsheet_id, doc_del)
        ref_desk_hours = service.get_spreadsheet_values(spreadsheet_id, ref_desk)
        v_ref_hours = service.get_spreadsheet_values(spreadsheet_id, v_ref)
        thinktank_hours = service.get_spreadsheet_values(spreadsheet_id, thinktank)
        scrc_hours = service.get_spreadsheet_values(spreadsheet_id, scrc)
        blockson_hours = service.get_spreadsheet_values(spreadsheet_id, blockson)
        dsc_hours = service.get_spreadsheet_values(spreadsheet_id, dsc)
        ambler_hours = service.get_spreadsheet_values(spreadsheet_id, ambler)
        guest_computers_hours = service.get_spreadsheet_values(spreadsheet_id, guest_computers)

        locations_array = Array.new
        dates_array = Array.new
        paley_hours_array = Array.new
        media_hours_array = Array.new
        doc_del_hours_array = Array.new
        ref_desk_hours_array = Array.new
        v_ref_hours_array = Array.new
        thinktank_hours_array = Array.new
        scrc_hours_array = Array.new
        blockson_hours_array = Array.new
        dsc_hours_array = Array.new
        ambler_hours_array = Array.new
        guest_computers_hours_array = Array.new

        locations.values.each do |location|
          locations_array.push(location)
        end
        locations_array = locations_array.first.drop(1)

        dates.values.each do |date|
          dates_array.push(date)
        end
        paley_hours.values.each do |hour|
          paley_hours_array.push(hour)
        end
        media_hours.values.each do |hour|
          media_hours_array.push(hour)
        end
        doc_del_hours.values.each do |hour|
          doc_del_hours_array.push(hour)
        end
        ref_desk_hours.values.each do |hour|
          ref_desk_hours_array.push(hour)
        end
        v_ref_hours.values.each do |hour|
          v_ref_hours_array.push(hour)
        end
        thinktank_hours.values.each do |hour|
          thinktank_hours_array.push(hour)
        end
        scrc_hours.values.each do |hour|
          scrc_hours_array.push(hour)
        end
        blockson_hours.values.each do |hour|
          blockson_hours_array.push(hour)
        end
        dsc_hours.values.each do |hour|
          dsc_hours_array.push(hour)
        end
        ambler_hours.values.each do |hour|
          ambler_hours_array.push(hour)
        end
        guest_computers_hours.values.each do |hour|
          guest_computers_hours_array.push(hour)
        end

        paley_hours_hash = Hash[dates_array.zip(paley_hours_array)]

        paley_hours_hash.each do |hours|
          time = LibraryHours.new(location: 'Paley Library',
                                    location_id: "1", 
                                    date: hours.first.to_s.to_date, 
                                    hours: hours.last.to_s.gsub(/[\["\]]/, ''))
          time.save
        end

        media_hours_hash = Hash[dates_array.zip(media_hours_array)]
        media_hours_hash.each do |hours|
          time = LibraryHours.new(location: 'Media Services',
                                    location_id: "2", 
                                    date: hours.first.to_s.to_date, 
                                    hours: hours.last.to_s.gsub(/[\["\]]/, ''))
          time.save
        end
        doc_del_hours_hash = Hash[dates_array.zip(doc_del_hours_array)]
        doc_del_hours_hash.each do |hours|
          time = LibraryHours.new(location: 'Document Delivery',
                                    location_id: "3", 
                                    date: hours.first.to_s.to_date, 
                                    hours: hours.last.to_s.gsub(/[\["\]]/, ''))
          time.save
        end
        ref_desk_hours_hash = Hash[dates_array.zip(ref_desk_hours_array)]
        ref_desk_hours_hash.each do |hours|
          time = LibraryHours.new(location: 'Reference Desk',
                                    location_id: "4", 
                                    date: hours.first.to_s.to_date, 
                                    hours: hours.last.to_s.gsub(/[\["\]]/, ''))
          time.save
        end
        v_ref_hours_hash = Hash[dates_array.zip(v_ref_hours_array)]
        v_ref_hours_hash.each do |hours|
          time = LibraryHours.new(location: 'Virtual Reference',
                                    location_id: "5", 
                                    date: hours.first.to_s.to_date, 
                                    hours: hours.last.to_s.gsub(/[\["\]]/, ''))
          time.save
        end
        thinktank_hours_hash = Hash[dates_array.zip(thinktank_hours_array)]
        thinktank_hours_hash.each do |hours|
          time = LibraryHours.new(location: 'Think Tank',
                                    location_id: "6", 
                                    date: hours.first.to_s.to_date, 
                                    hours: hours.last.to_s.gsub(/[\["\]]/, ''))
          time.save
        end
        scrc_hours_hash = Hash[dates_array.zip(scrc_hours_array)]
        scrc_hours_hash.each do |hours|
          time = LibraryHours.new(location: 'Special Collections Research Center',
                                    location_id: "7", 
                                    date: hours.first.to_s.to_date, 
                                    hours: hours.last.to_s.gsub(/[\["\]]/, ''))
          time.save
        end
        blockson_hours_hash = Hash[dates_array.zip(blockson_hours_array)]
        blockson_hours_hash.each do |hours|
          time = LibraryHours.new(location: 'Charles L. Blockson Collection',
                                    location_id: "8", 
                                    date: hours.first.to_s.to_date, 
                                    hours: hours.last.to_s.gsub(/[\["\]]/, ''))
          time.save
        end
        dsc_hours_hash = Hash[dates_array.zip(dsc_hours_array)]
        dsc_hours_hash.each do |hours|
          time = LibraryHours.new(location: 'Digital Scholarship Center',
                                    location_id: "9", 
                                    date: hours.first.to_s.to_date, 
                                    hours: hours.last.to_s.gsub(/[\["\]]/, ''))
          time.save
        end
        ambler_hours_hash = Hash[dates_array.zip(ambler_hours_array)]
        ambler_hours_hash.each do |hours|
          time = LibraryHours.new(location: 'Ambler Campus Library',
                                    location_id: "10", 
                                    date: hours.first.to_s.to_date, 
                                    hours: hours.last.to_s.gsub(/[\["\]]/, ''))
          time.save
        end
        guest_computers_hours_hash = Hash[dates_array.zip(guest_computers_hours_array)]
        guest_computers_hours_hash.each do |hours|
          time = LibraryHours.new(location: 'Guest Computers',
                                    location_id: "11", 
                                    date: hours.first.to_s.to_date, 
                                    hours: hours.last.to_s.gsub(/[\["\]]/, ''))
          time.save
        end


      

    end #task
  end #namespace: seed
end #namespace: db
