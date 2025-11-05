# frozen_string_literal: true

class ExcelUpdateJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: 5.seconds, attempts: 3

  def perform(form_data, file_id = nil, worksheet_name = nil)
    file_id ||= Rails.application.credentials.microsoft[:spreadsheet_file_id]
    worksheet_name ||= "AV-Requests"

    Rails.logger.info "ExcelUpdateJob starting for worksheet #{worksheet_name}, file #{file_id}"

    excel_service = MicrosoftExcelService.new
    headers = headers_for(worksheet_name)

    excel_service.create_headers_if_needed(file_id, worksheet_name, headers)
    excel_service.append_form_data_to_excel(file_id, worksheet_name, form_data, headers)

    Rails.logger.info "Form data successfully added to Excel spreadsheet"
  rescue => e
    Rails.logger.error "Failed to update Excel: #{e.class} - #{e.message}"
    raise e
  end

  private

  def headers_for(worksheet_name)
    case worksheet_name
    when "CopyRequests"
      [
        "Name",
        "Email",
        "Phone",
        "Affiliation",
        "Address",
        "Collection Title",
        "Box",
        "Folder",
        "Identifier / Description",
        "Estimated Pages",
        "Format",
        "Additional Requests",
        "Duplication Limits",
        "Copyright Acknowledgment",
        "Submitted At",
      ]
    else
      [
        "Name",
        "Email",
        "Phone",
        "Affiliation",
        "Address",
        "Collection Title",
        "Identifier / Description",
        "Notes",
        "Format",
        "Additional Requests",
        "Outside Vendor Fees",
        "Duplication Limits",
        "Copyright Acknowledgment",
        "Submitted At",
      ]
    end
  end
end
