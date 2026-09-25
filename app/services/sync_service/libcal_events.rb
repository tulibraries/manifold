# frozen_string_literal: true

require "json"
require "logger"

class SyncService::LibcalEvents
  include SyncService::Libcal::Errors

  def self.call(events_url: nil, events_urls: nil, event_ids: nil, access_token: nil, force: false, response_body: nil)
    new(events_url:, events_urls:, event_ids:, access_token:, force:, response_body:).sync
  end

  def initialize(params = {})
    @log = Logger.new("log/sync-libcal-event.log")
    @stdout = Logger.new(STDOUT)
    @events_urls = event_source_resolver.resolve(params)
    @access_token = params[:access_token].presence
    @response_body = params[:response_body]
    error_reporter.log("Syncing LibCal events from #{source_label}")
  end

  def sync
    @updated = @errored = 0

    events = fetch_events_or_report

    events.each do |raw_event|
      begin
        @log.info("Syncing LibCal Event #{event_mapper.title(raw_event)} on #{event_mapper.start_time(raw_event)}")
        create_or_update_if_needed!(raw_event)
      rescue StandardError => err
        report_error(err, raw_event)
        @errored += 1
      end
    end

    send_image_failures_to_cache
    stdout_and_log("LibCal syncing completed with #{@updated} updated and #{@errored} errored records -- with #{image_attacher.failures.size} image failures.")
  end

  def read_events
    return events_reader.read_body(@response_body) if @response_body.present?
    raise MissingEventsSourceException, "No LibCal events source configured" if @events_urls.blank?

    events_reader.read(@events_urls)
  end

  def record_hash(raw_event)
    event_mapper.map(raw_event)
  end

  def create_or_update_if_needed!(raw_event)
    record = record_hash(raw_event)

    event_persister.persist(record)
    stdout_and_log(%Q(Successfully saved LibCal record for #{record["title"]}))
    @updated += 1
  end

  def send_image_failures_to_cache
    failures = image_attacher.failures
    return Rails.cache.delete("events_image_error") if failures.empty?

    Rails.cache.write("events_image_error", failures.map(&:title), expires_in: 1.day)
  end

  private

    def fetch_events_or_report
      read_events
    rescue StandardError => err
      raise error_reporter.report(err,
        message: "LibCal sync aborted before processing any events - #{err.message}\n#{err.backtrace.join("\n")}",
        context: { libcal_sources: reported_sources })
    end

    def report_error(err, raw_event)
      title = event_mapper.title(raw_event)

      error_reporter.report(err,
        message: %Q(Syncing LibCal Event #{title} errored - #{err.message}\n#{err.backtrace.join("\n")}),
        context: {
          libcal_sources: reported_sources,
          libcal_event_id: (raw_event["id"] if raw_event.is_a?(Hash)),
          libcal_event_title: title
        })
    end

    def fetch_access_token
      access_token_fetcher.fetch
    end

    def source_query_params(id)
      event_source_resolver.source_query_params(id)
    end

    def event_source_resolver
      @event_source_resolver ||= SyncService::Libcal::EventSourceResolver.new
    end

    def access_token_fetcher
      @access_token_fetcher ||= SyncService::Libcal::AccessTokenFetcher.new
    end

    def events_reader
      @events_reader ||= SyncService::Libcal::EventsReader.new(
        access_token: @access_token,
        token_provider: -> { fetch_access_token }
      )
    end

    def event_mapper
      @event_mapper ||= SyncService::Libcal::EventMapper.new
    end

    def image_attacher
      @image_attacher ||= SyncService::Libcal::ImageAttacher.new(error_reporter:)
    end

    def error_reporter
      @error_reporter ||= SyncService::Libcal::ErrorReporter.new(logger: ->(message) { stdout_and_log(message) })
    end

    def event_persister
      @event_persister ||= SyncService::Libcal::EventPersister.new(image_attacher:)
    end

    def source_label
      @events_urls.presence&.join(", ") || "provided response body"
    end

    def reported_sources
      return "provided response body" if @response_body.present?

      error_reporter.redact_sources(@events_urls)
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      # @stdout.send(level, message)
    end
end
