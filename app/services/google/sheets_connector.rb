# frozen_string_literal: true

require "google/apis/sheets_v4"

module Google
  class SheetsConnector < ApplicationService
    def initialize(*args)
      begin
        @service = Google::Apis::SheetsV4::SheetsService.new
        @service.key = Rails.configuration.google_sheets_api_key
        @spreadsheet_id = Rails.configuration.etexts_spreadsheet_id
        @etext_coordinates = Rails.configuration.etexts_spreadsheet_etext_cells
      rescue => e
        e.message
      end
    end

    def call
      @service.get_spreadsheet_values(@spreadsheet_id, @etext_coordinates)
    end
  end
end
