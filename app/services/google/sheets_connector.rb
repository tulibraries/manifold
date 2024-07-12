# frozen_string_literal: true

require "google/apis/sheets_v4"

module Google
  class SheetsConnector < ApplicationService
    def initialize(*args)
      @feature = args.first[:feature]
      @scope = args.first[:scope]
      case @feature
      when "etexts"
        @spreadsheet_id = Rails.configuration.etexts_spreadsheet_id
        @cells = Rails.configuration.etexts_spreadsheet_etext_cells
      when "hours"
        @spreadsheet_id = Rails.configuration.hours_spreadsheet_id
        @scope.present? ? 
          @cells = get_location(@scope)
          :
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
      if @feature == "hours" 
        if @scope.present?
          response = @service.batch_get_spreadsheet_values(@spreadsheet_id, ranges: ["A2:A","#{@cells}"], major_dimension: "ROWS")
        else
          response = @service.get_spreadsheet_values(@spreadsheet_id, "HOURS!#{@cells}")
        end
      else
        response = @service.get_spreadsheet_values(@spreadsheet_id, @cells)
      end
    end

    private

    def get_location(location)
      case location
      when "charles"
        Rails.application.config.hours_worksheet_charles
      when "24-7"
        Rails.application.config.hours_worksheet_24_7
      when "asrs"
        Rails.application.config.hours_worksheet_asrs
      when "guest_computers"
        Rails.application.config.hours_worksheet_guest_computers
      when "scholars_studio"
        Rails.application.config.hours_worksheet_scholars_studio
      when "service_zone"
        Rails.application.config.hours_worksheet_service_zone
      when "scrc"
        Rails.application.config.hours_worksheet_scrc
      when "cafe"
        Rails.application.config.hours_worksheet_cafe
      when "exhibits"
        Rails.application.config.hours_worksheet_exhibits
      when "ambler"
        Rails.application.config.hours_worksheet_ambler
      when "blockson"
        Rails.application.config.hours_worksheet_blockson
      when "ginsburg"
        Rails.application.config.hours_worksheet_ginsburg
      when "innovation"
        Rails.application.config.hours_worksheet_innovation
      when "podiatry"
        Rails.application.config.hours_worksheet_podiatry
      when "ask_a_librarian"
        Rails.application.config.hours_worksheet_ask_a_librarian
      when "success_center"
        Rails.application.config.hours_worksheet_success_center
      end
    end
  end
end
