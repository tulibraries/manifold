# frozen_string_literal: true

require "google/apis/sheets_v4"

module Google
  class SheetsConnector < ApplicationService
    def initialize(*args)
      feature = args.first[:feature]
      scope = args.first[:scope]
      case feature
      when "etexts"
        @spreadsheet_id = Rails.configuration.etexts_spreadsheet_id
        @cells = Rails.configuration.etexts_spreadsheet_etext_cells
      when "hours"
        @spreadsheet_id = Rails.configuration.hours_spreadsheet_id
        scope.present? ? 
          @cells = get_location(scope)
          :
          @cells = Rails.configuration.hours_spreadsheet_date_cells
      end
      begin
        @service = Google::Apis::SheetsV4::SheetsService.new
        @service.key = Rails.configuration.google_sheets_api_key
      rescue => e
        e.message
      end
      feature = args.first[:feature]
      scope = args.first[:scope]
      case feature
      when "etexts"
        @spreadsheet_id = Rails.configuration.etexts_spreadsheet_id
        @cells = Rails.configuration.etexts_spreadsheet_etext_cells
      when "hours"
        @spreadsheet_id = Rails.configuration.hours_spreadsheet_id
        scope.present? ? 
          @cells = get_location(scope)
          :
          @cells = Rails.configuration.hours_spreadsheet_date_cells
      end
    end

    def call
      @service.get_spreadsheet_values(@spreadsheet_id, @cells)
    end

    private

    def get_location(location)
      today = config.hours_worksheet_range_info
      case location
      when "charles"
        range = config.hours_worksheet_charles
      when "24-7"
        config.hours_worksheet_24_7
      when "asrs"
        config.hours_worksheet_asrs
      when "guest_computers"
        config.hours_worksheet_guest_computers
      when "scholars_studio"
        config.hours_worksheet_scholars_studio
      when "service_zone"
        config.hours_worksheet_service_zone
      when "scrc"
        config.hours_worksheet_scrc
      when "cafe"
        config.hours_worksheet_cafe
      when "exhibits"
        config.hours_worksheet_exhibits
      when "ambler"
        config.hours_worksheet_ambler
      when "blockson"
        config.hours_worksheet_blockson
      when "ginsburg"
        config.hours_worksheet_ginsburg
      when "innovation"
        config.hours_worksheet_innovation
      when "podiatry"
        config.hours_worksheet_podiatry
      when "ask_a_librarian"
        config.hours_worksheet_ask_a_librarian
      when "success_center"
        config.hours_worksheet_success_center
      end
    end
  end
end
