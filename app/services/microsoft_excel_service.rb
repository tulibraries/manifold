# frozen_string_literal: true

class MicrosoftExcelService
  def initialize(client: MicrosoftGraph::Client.new)
    @client = client
  end

  def append_form_data_to_excel(file_id, worksheet_name, form_data, headers)
    Rails.logger.info "Preparing Excel update for file #{file_id}, worksheet #{worksheet_name}"
    row_data = format_form_data(form_data, worksheet_name)
    Rails.logger.debug "Excel update form data keys: #{form_data.respond_to?(:keys) ? form_data.keys : []}"
    Rails.logger.debug "Excel row data preview: #{row_data.inspect}"
    used_range = get_used_range(file_id, worksheet_name)
    next_row = calculate_next_row(used_range)
    Rails.logger.info(
      "Appending row #{next_row} (used range rowIndex=#{used_range&.dig('rowIndex') || 0}, rowCount=#{used_range&.dig('rowCount') || 0})",
    )
    range_address = build_range_address(next_row, headers.length)

    Rails.logger.info "Appending to Excel: #{range_address}"

    response = @client.patch(
      @client.workbook_endpoint(file_id, "worksheets/#{@client.encode_segment(worksheet_name)}/range(address='#{range_address}')"),
      body: { values: [row_data] }.to_json,
    )

    handle_response(response)
  end

  def create_headers_if_needed(file_id, worksheet_name, headers)
    first_row = get_range_values(file_id, worksheet_name, "A1:Z1")
    if first_row && first_row["values"].present?
      Rails.logger.debug "Excel headers already present for file #{file_id}, worksheet #{worksheet_name}"
      return
    end

    Rails.logger.info "Creating Excel headers for file #{file_id}, worksheet #{worksheet_name}"

    range_address = build_range_address(1, headers.length)

    @client.patch(
      @client.workbook_endpoint(file_id, "worksheets/#{@client.encode_segment(worksheet_name)}/range(address='#{range_address}')"),
      body: { values: [headers] }.to_json,
    )
  end

  private

    def get_used_range(file_id, worksheet_name)
      Rails.logger.debug "Fetching used range for file #{file_id}, worksheet #{worksheet_name}"
      response = @client.get(
        @client.workbook_endpoint(file_id, "worksheets/#{@client.encode_segment(worksheet_name)}/usedRange"),
      )

      response.success? ? JSON.parse(response.body) : nil
    rescue => e
      Rails.logger.warn "Could not get used range: #{e.message}"
      nil
    end

    def get_range_values(file_id, worksheet_name, range_address)
      Rails.logger.debug "Fetching range #{range_address} for file #{file_id}, worksheet #{worksheet_name}"
      response = @client.get(
        @client.workbook_endpoint(file_id, "worksheets/#{@client.encode_segment(worksheet_name)}/range(address='#{range_address}')"),
      )

      response.success? ? JSON.parse(response.body) : nil
    end

    def build_range_address(row_number, column_count)
      start_col = "A"
      end_col = (column_count - 1 + "A".ord).chr
      "#{start_col}#{row_number}:#{end_col}#{row_number}"
    end

    def calculate_next_row(used_range)
      return 1 unless used_range

      row_index = used_range["rowIndex"].to_i
      row_count = used_range["rowCount"].to_i

      return 1 if row_count.zero?

      row_index + row_count + 1
    end

    def format_form_data(form_data, worksheet_name)
      case worksheet_name
      when "Copy-Requests"
        format_copy_request(form_data)
      else
        format_av_request(form_data)
      end
    end

    def handle_response(response)
      if response.success?
        Rails.logger.info "Successfully updated Excel spreadsheet (status #{response.code})"
        JSON.parse(response.body)
      else
        error_msg = "Excel API Error: #{response.code} - #{response.body}"
        Rails.logger.error error_msg
        raise error_msg
      end
    end

    def format_av_request(form_data)
      [
        fetch_value(form_data, :name),
        fetch_value(form_data, :email),
        fetch_value(form_data, :phone),
        affiliation_label(fetch_value(form_data, :affiliation)),
        fetch_value(form_data, :address),
        summarize_requests(
          form_data,
          base_fields: %i[collection_title identifier notes format],
          field_labels: {
            collection_title: "Collection",
            identifier: "Identifier",
            notes: "Notes",
            format: "Format",
          },
          format_labeler: method(:av_format_label),
        ),
        boolean_label(fetch_value(form_data, :outside_vendor_fees)),
        boolean_label(fetch_value(form_data, :duplication_limits)),
        boolean_label(fetch_value(form_data, :copyright_acknowledgment)),
        timestamp_value,
      ]
    end

    def format_copy_request(form_data)
      [
        fetch_value(form_data, :name),
        fetch_value(form_data, :email),
        fetch_value(form_data, :phone),
        affiliation_label(fetch_value(form_data, :affiliation)),
        fetch_value(form_data, :address),
        summarize_requests(
          form_data,
          base_fields: %i[collection_title box folder identifier estimated_pages format],
          field_labels: {
            collection_title: "Collection",
            box: "Box",
            folder: "Folder",
            identifier: "Identifier",
            estimated_pages: "Estimated Pages",
            format: "Format",
          },
          format_labeler: method(:copy_format_label),
        ),
        boolean_label(fetch_value(form_data, :duplication_limits)),
        boolean_label(fetch_value(form_data, :copyright_acknowledgment)),
        timestamp_value,
      ]
    end

    def summarize_requests(form_data, base_fields:, field_labels:, format_labeler:)
      (0..9).map do |index|
        request_parts = base_fields.each_with_object([]) do |field, parts|
          key = index.zero? ? field : "#{field}_#{index.to_s.rjust(2, '0')}"
          value = fetch_value(form_data, key)
          next if value.blank?

          label = field_labels.fetch(field)
          formatted_value = if field == :format && format_labeler
            format_labeler.call(value)
          else
            value
          end

          parts << "#{label}: #{formatted_value}"
        end

        next if request_parts.empty?

        "Request #{index + 1}: #{request_parts.join(' | ')}"
      end.compact.join("\n")
    end

    def fetch_value(form_data, key)
      form_data[key] || form_data[key.to_s]
    end

    def affiliation_label(code)
      {
        "temple" => "Temple University Affiliates",
        "non-temple" => "Non-Temple Affiliates",
      }[code.to_s] || code
    end

    def av_format_label(code)
      {
        "film" => "Film",
        "video" => "Video",
        "audio" => "Audio",
      }[code.to_s] || code
    end

    def copy_format_label(code)
      {
        "tiff" => "TIFF (600 DPI): $5 per image",
        "pdf" => "PDF: $0.50 per page",
        "photocopy" => "Photocopy: $0.50 per page plus postage",
      }[code.to_s] || code
    end

    def boolean_label(value)
      cast = ActiveModel::Type::Boolean.new.cast(value)
      return "" if cast.nil?

      cast ? "Yes" : "No"
    end

    def timestamp_value
      Time.current.strftime("%Y-%m-%d %H:%M:%S")
    end
end
