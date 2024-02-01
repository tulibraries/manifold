# frozen_string_literal: true

require "google/apis/sheets_v4"

module Google
  class SheetsConnector < ApplicationService
    def initialize(*args)
      feature = args.first[:feature]
      case feature
      when "etexts"
        @spreadsheet_id = Rails.configuration.etexts_spreadsheet_id
        @cells = Rails.configuration.etexts_spreadsheet_etext_cells
      when "hours"
        @spreadsheet_id = Rails.configuration.hours_spreadsheet_id
        @cells = Rails.configuration.hours_spreadsheet_date_cells
      end
      begin
        @service = Google::Apis::SheetsV4::SheetsService.new
        @service.key = Rails.configuration.google_sheets_api_key
      rescue => e
        e.message
      end
    end

    def call
      @service.get_spreadsheet_values(@spreadsheet_id, @cells)
    end
  end
end
