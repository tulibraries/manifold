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
        @client.workbook_endpoint(file_id, "worksheets/#{@client.encode_segment(worksheet_name)}/usedRange(valuesOnly=true)"),
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
      values = used_range["values"] || []

      last_data_offset = values.rindex do |row|
        Array(row).any? { |cell| cell.present? && cell.to_s.strip != "" }
      end

      return row_index + 1 if last_data_offset.nil?

      row_index + last_data_offset + 2
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
          form_type: "av-requests",
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
          form_type: "copy-requests",
        ),
        boolean_label(fetch_value(form_data, :duplication_limits)),
        boolean_label(fetch_value(form_data, :copyright_acknowledgment)),
        timestamp_value,
      ]
    end

    def summarize_requests(form_data, form_type:)
      fields = Form::RequestDefinition.request_fields(form_type)

      Form::RequestDefinition.slots.map do |slot|
        request_parts = fields.each_with_object([]) do |field, parts|
          key = Form::RequestDefinition.field_key(field, slot)
          value = fetch_value(form_data, key)
          next if value.blank?

          label = Form::RequestDefinition.field_label(
            form_type,
            field,
            surface: :excel,
          )

          formatted_value =
            if field == :format
              Form::RequestDefinition.format_label(
                form_type,
                value,
                surface: :excel,
              )
            else
              value
            end

          parts << "#{label}: #{formatted_value}"
        end

        next if request_parts.empty?

        "Request #{slot + 1}: #{request_parts.join(' | ')}"
      end.compact.join("\n")
    end

    def fetch_value(form_data, key)
      [key, key.to_s, key.to_sym].uniq.each do |candidate|
        return form_data[candidate] if form_data.key?(candidate)
      end

      nil
    end

    def affiliation_label(code)
      {
        "temple" => "Temple University Affiliates",
        "non-temple" => "Non-Temple Affiliates",
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
