# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "json"

class SyncService::Libcal::EventsReader
  include SyncService::Libcal::Errors

  def initialize(access_token:, token_provider:)
    @access_token = access_token
    @token_provider = token_provider
  end

  def read(sources)
    sources.flat_map { |source| extract_events(JSON.parse(read_response_body(source))) }
      .uniq { |event| event["id"].to_s }
  end

  def read_body(response_body)
    extract_events(JSON.parse(response_body))
  end

  private

    def read_response_body(source)
      return File.read(source) if File.exist?(source)

      read_remote_response_body(source)
    end

    def read_remote_response_body(source, retry_on_unauthorized: true)
      @access_token = @access_token.presence || @token_provider.call

      URI.open(source, request_options(@access_token)).read
    rescue OpenURI::HTTPError => err
      raise unless retry_on_unauthorized && unauthorized_response?(err)

      @access_token = @token_provider.call
      read_remote_response_body(source, retry_on_unauthorized: false)
    end

    def request_options(access_token)
      request_options = {
        read_timeout: Rails.configuration.sync_timeout,
        open_timeout: Rails.configuration.sync_timeout
      }
      request_options["Authorization"] = "Bearer #{access_token}" if access_token.present?
      request_options
    end

    def unauthorized_response?(error)
      error.io.respond_to?(:status) && error.io.status.first.to_i == 401
    end

    def extract_events(payload)
      case payload
      when Array
        payload
      when Hash
        payload["events"] || payload["data"] || payload["items"] || Array.wrap(payload["event"]).compact.presence ||
          raise(UnexpectedResponseShapeException, "Unsupported LibCal response shape: #{payload.keys.sort.join(', ')}")
      else
        raise UnexpectedResponseShapeException, "Unsupported LibCal response body: #{payload.class}"
      end
    end
end
