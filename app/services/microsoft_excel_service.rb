# frozen_string_literal: true

require "microsoft_graph"
require "httparty"
require "cgi"

class MicrosoftExcelService
  include HTTParty
  base_uri "https://graph.microsoft.com/v1.0"

  def initialize
    credentials = Rails.application.credentials.microsoft
    @tenant_id = credentials[:tenant_id]
    @client_id = credentials[:client_id]
    @client_secret = credentials[:client_secret]
    @drive_id = credentials[:drive_id]
    @site_id = credentials[:site_id]
    @site_hostname = credentials[:site_hostname]
    @site_path = credentials[:site_path]&.sub(%r{^/+}, "")

    validate_site_configuration!

    @access_token = access_token
    @headers = {
      "Authorization" => "Bearer #{@access_token}",
      "Content-Type" => "application/json",
    }
  end

  def append_form_data_to_excel(file_id, worksheet_name, form_data, headers)
    Rails.logger.info "Preparing Excel update for file #{file_id}, worksheet #{worksheet_name}"
    row_data = format_form_data(form_data, worksheet_name)
    Rails.logger.debug "Excel update form data keys: #{form_data.respond_to?(:keys) ? form_data.keys : []}"
    Rails.logger.debug "Excel row data preview: #{row_data.inspect}"
    used_range = get_used_range(file_id, worksheet_name)
    next_row = used_range ? used_range["rowCount"].to_i + 1 : 1
    Rails.logger.info "Appending row #{next_row} (used range rowCount=#{used_range&.dig('rowCount') || 0})"
    range_address = build_range_address(next_row, headers.length)

    Rails.logger.info "Appending to Excel: #{range_address}"

    response = self.class.patch(
      workbook_endpoint(file_id, "worksheets/#{encode_segment(worksheet_name)}/range(address='#{range_address}')"),
      headers: @headers,
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

    self.class.patch(
      workbook_endpoint(file_id, "worksheets/#{encode_segment(worksheet_name)}/range(address='#{range_address}')"),
      headers: @headers,
      body: { values: [headers] }.to_json,
    )
  end

  private

  def access_token
    auth_url = "https://login.microsoftonline.com/#{@tenant_id}/oauth2/v2.0/token"
    response = HTTParty.post(
      auth_url,
      body: {
        grant_type: "client_credentials",
        client_id: @client_id,
        client_secret: @client_secret,
        scope: "https://graph.microsoft.com/.default",
      },
      headers: { "Content-Type" => "application/x-www-form-urlencoded" },
    )

    return JSON.parse(response.body)["access_token"] if response.success?

    raise "Failed to get access token: #{response.body}"
  end

  def validate_site_configuration!
    return if @drive_id.present?
    return if @site_id.present?
    return if @site_hostname.present? && @site_path.present?

    raise "SharePoint site configuration missing. Provide :drive_id or :site_id, or both :site_hostname and :site_path in credentials."
  end

  def workbook_endpoint(file_id, resource_path)
    "#{workbook_item_path(file_id)}/workbook/#{resource_path}"
  end

  def workbook_item_path(file_id)
    if @drive_id.present?
      "/drives/#{@drive_id}/items/#{file_id}"
    elsif @site_id.present?
      "/sites/#{@site_id}/drive/items/#{file_id}"
    else
      "/sites/#{@site_hostname}:/#{@site_path}:/drive/items/#{file_id}"
    end
  end

  def encode_segment(value)
    CGI.escape(value.to_s)
  end

  def get_used_range(file_id, worksheet_name)
    Rails.logger.debug "Fetching used range for file #{file_id}, worksheet #{worksheet_name}"
    response = self.class.get(
      workbook_endpoint(file_id, "worksheets/#{encode_segment(worksheet_name)}/usedRange"),
      headers: @headers,
    )

    response.success? ? JSON.parse(response.body) : nil
  rescue => e
    Rails.logger.warn "Could not get used range: #{e.message}"
    nil
  end

  def get_range_values(file_id, worksheet_name, range_address)
    Rails.logger.debug "Fetching range #{range_address} for file #{file_id}, worksheet #{worksheet_name}"
    response = self.class.get(
      workbook_endpoint(file_id, "worksheets/#{encode_segment(worksheet_name)}/range(address='#{range_address}')"),
      headers: @headers,
    )

    response.success? ? JSON.parse(response.body) : nil
  end

  def build_range_address(row_number, column_count)
    start_col = "A"
    end_col = (column_count - 1 + "A".ord).chr
    "#{start_col}#{row_number}:#{end_col}#{row_number}"
  end

  def format_form_data(form_data, worksheet_name)
    case worksheet_name
    when "CopyRequests"
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
      fetch_value(form_data, :collection_title),
      fetch_value(form_data, :identifier),
      fetch_value(form_data, :notes),
      av_format_label(fetch_value(form_data, :format)),
      summarize_av_additional_requests(form_data),
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
      fetch_value(form_data, :collection_title),
      fetch_value(form_data, :box),
      fetch_value(form_data, :folder),
      fetch_value(form_data, :identifier),
      fetch_value(form_data, :estimated_pages),
      copy_format_label(fetch_value(form_data, :format)),
      summarize_copy_additional_requests(form_data),
      boolean_label(fetch_value(form_data, :duplication_limits)),
      boolean_label(fetch_value(form_data, :copyright_acknowledgment)),
      timestamp_value,
    ]
  end

  def summarize_av_additional_requests(form_data)
    summarize_additional_requests(
      form_data,
      fields: %w[collection_title identifier notes format],
      formatter: lambda do |request|
        parts = []
        parts << "Collection: #{request['collection_title']}" if request["collection_title"].present?
        parts << "Identifier: #{request['identifier']}" if request["identifier"].present?
        parts << "Notes: #{request['notes']}" if request["notes"].present?
        parts << "Format: #{av_format_label(request['format'])}" if request["format"].present?
        parts.join(" | ")
      end,
    )
  end

  def summarize_copy_additional_requests(form_data)
    summarize_additional_requests(
      form_data,
      fields: %w[collection_title box folder identifier estimated_pages format],
      formatter: lambda do |request|
        parts = []
        parts << "Collection: #{request['collection_title']}" if request["collection_title"].present?
        parts << "Box: #{request['box']}" if request["box"].present?
        parts << "Folder: #{request['folder']}" if request["folder"].present?
        parts << "Identifier: #{request['identifier']}" if request["identifier"].present?
        parts << "Estimated Pages: #{request['estimated_pages']}" if request["estimated_pages"].present?
        parts << "Format: #{copy_format_label(request['format'])}" if request["format"].present?
        parts.join(" | ")
      end,
    )
  end

  def summarize_additional_requests(form_data, fields:, formatter:)
    additional = (1..9).map do |index|
      prefix = index.to_s.rjust(2, "0")
      request = fields.each_with_object({}) do |field, hash|
        key = "#{field}_#{prefix}"
        hash[field] = fetch_value(form_data, key)
      end

      next if request.values.all?(&:blank?)

      summary = formatter.call(request)
      summary.present? ? "Request #{index + 1}: #{summary}" : nil
    end.compact

    additional.join("\n")
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
