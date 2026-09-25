# frozen_string_literal: true

require "net/http"
require "json"

class SyncService::Libcal::AccessTokenFetcher
  include SyncService::Libcal::Errors

  def fetch
    token_url = Rails.configuration.libcal_token_url.to_s
    client_id = Rails.configuration.libcal_client_id.to_s
    client_secret = Rails.configuration.libcal_client_secret.to_s

    if token_url.blank? || client_id.blank? || client_secret.blank?
      raise MissingAccessTokenConfigurationException,
        "LibCal token URL, client ID, and client secret must be configured"
    end

    response = request_token(token_url, client_id, client_secret)
    payload = JSON.parse(response.body)
    token = payload["access_token"].presence
    return token if response.is_a?(Net::HTTPSuccess) && token.present?

    raise MissingAccessTokenConfigurationException, "Unable to fetch LibCal access token: #{response.code} #{error_description(payload)}"
  end

  private

    def error_description(payload)
      return "(no error details in response)" unless payload.is_a?(Hash)

      (payload["error_description"] || payload["error"]).presence || "(no error details in response)"
    end

    def request_token(token_url, client_id, client_secret)
      uri = URI.parse(token_url)
      request = Net::HTTP::Post.new(uri)
      request.basic_auth(client_id, client_secret)
      request["Content-Type"] = "application/x-www-form-urlencoded"
      request.set_form_data("grant_type" => "client_credentials")

      Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: uri.scheme == "https",
        open_timeout: Rails.configuration.sync_timeout,
        read_timeout: Rails.configuration.sync_timeout
      ) { |http| http.request(request) }
    end
end
