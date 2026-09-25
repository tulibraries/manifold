# frozen_string_literal: true

class SyncService::Libcal::EventSourceResolver
  include SyncService::Libcal::Errors

  LIBCAL_MAX_DAYS = 365
  LIBCAL_MAX_LIMIT = 500

  def resolve(params)
    explicit_ids = extract_ids(params[:event_ids])
    explicit_sources = Array.wrap(params[:events_urls]).flatten.compact
    explicit_sources << params[:events_url] if params[:events_url].present?

    configured_ids = extract_ids(Rails.configuration.libcal_events_ids)
    configured_sources = sources_from_ids(configured_ids) ||
      Array.wrap(Rails.configuration.libcal_events_url).compact.presence

    extract_ids(sources_from_ids(explicit_ids) || explicit_sources.presence || configured_sources)
  end

  def source_query_params(id)
    start_date = libcal_start_date
    days = [(libcal_end_date - start_date).to_i + 1, LIBCAL_MAX_DAYS].min

    [
      ["cal_id", id],
      ["date", start_date.iso8601],
      ["days", days],
      ["limit", LIBCAL_MAX_LIMIT]
    ]
  end

  private

    def sources_from_ids(ids)
      ids = extract_ids(ids)
      return if ids.blank?

      base_url = Rails.configuration.libcal_events_url.to_s.strip
      raise MissingEventsSourceException, "No LibCal events base URL configured" if base_url.blank?

      ids.map do |id|
        uri = URI.parse(base_url)
        existing_params = URI.decode_www_form(uri.query.to_s)
        uri.query = URI.encode_www_form(existing_params + source_query_params(id))
        uri.to_s
      end
    end

    def libcal_start_date
      configured_months(:libcal_events_lookback_months, default: 6).months.ago.to_date
    end

    def libcal_end_date
      configured_months(:libcal_events_lookahead_months, default: 12).months.from_now.to_date
    end

    def configured_months(setting, default:)
      months = Rails.configuration.public_send(setting).to_i
      months.positive? ? months : default
    end

    def extract_ids(value)
      Array.wrap(value)
        .flat_map { |entry| entry.to_s.split(",") }
        .map(&:strip)
        .reject(&:blank?)
    end
end
