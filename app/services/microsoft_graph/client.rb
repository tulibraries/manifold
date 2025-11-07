# frozen_string_literal: true

require "httparty"
require "cgi"

module MicrosoftGraph
  class Client
    include HTTParty
    base_uri "https://graph.microsoft.com/v1.0"

    def initialize(credentials = Rails.application.credentials.microsoft || {})
      @tenant_id = credentials[:tenant_id]
      @client_id = credentials[:client_id]
      @client_secret = credentials[:client_secret]
      @drive_id = credentials[:drive_id]
      @site_id = credentials[:site_id]
      @site_hostname = credentials[:site_hostname]
      @site_path = credentials[:site_path]&.sub(%r{^/+}, "")

      validate_site_configuration!
    end

    def headers
      @headers ||= {
        "Authorization" => "Bearer #{access_token}",
        "Content-Type" => "application/json",
      }
    end

    def get(path, options = {})
      self.class.get(path, merge_options(options))
    end

    def patch(path, options = {})
      self.class.patch(path, merge_options(options))
    end

    def post(path, options = {})
      self.class.post(path, merge_options(options))
    end

    def workbook_endpoint(file_id, resource_path)
      "#{workbook_item_path(file_id)}/workbook/#{resource_path}"
    end

    def encode_segment(value)
      CGI.escape(value.to_s)
    end

    private

      def merge_options(options)
        { headers: headers }.deep_merge(options)
      end

      def access_token
        @access_token ||= begin
          auth_url = "https://login.microsoftonline.com/#{@tenant_id}/oauth2/v2.0/token"
          response = self.class.post(
            auth_url,
            body: {
              grant_type: "client_credentials",
              client_id: @client_id,
              client_secret: @client_secret,
              scope: "https://graph.microsoft.com/.default",
            },
            headers: { "Content-Type" => "application/x-www-form-urlencoded" },
          )

          raise "Failed to get access token: #{response.body}" unless response.success?

          JSON.parse(response.body)["access_token"]
        end
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

      def validate_site_configuration!
        return if @drive_id.present?
        return if @site_id.present?
        return if @site_hostname.present? && @site_path.present?

        raise "SharePoint site configuration missing. Provide :drive_id or :site_id, or both :site_hostname and :site_path in credentials."
      end
  end
end
