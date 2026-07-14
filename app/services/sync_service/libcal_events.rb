# frozen_string_literal: true

require "json"
require "open-uri"
require "resolv-replace"
require "logger"
require "net/http"
require "socket"
require "tempfile"
require "digest"

class SyncService::LibcalEvents
  class MissingEventsSourceException < StandardError; end
  class UnexpectedResponseShapeException < StandardError; end
  class MissingAccessTokenConfigurationException < StandardError; end
  class MissingEventIdException < StandardError; end
  class ImageDownloadException < StandardError; end

  # The image CDN advertises AAAA records we cannot route to, so connect over the
  # A record while leaving the Host header and TLS SNI/cert check on the hostname.
  class Ipv4ConnectionAdapter < HTTParty::ConnectionAdapter
    def connection
      http = super
      ipv4 = Addrinfo.getaddrinfo(uri.host, nil, Socket::AF_INET, :STREAM).first&.ip_address
      raise ImageDownloadException, "No IPv4 address for #{uri.host}" if ipv4.blank?

      http.ipaddr = ipv4
      http
    end
  end

  def self.call(events_url: nil, events_urls: nil, event_ids: nil, access_token: nil, force: false, response_body: nil)
    new(events_url:, events_urls:, event_ids:, access_token:, force:, response_body:).sync
  end

  def initialize(params = {})
    @log = Logger.new("log/sync-libcal-event.log")
    @stdout = Logger.new(STDOUT)
    @events_urls = resolve_event_sources(params)
    @access_token = params[:access_token].presence
    @response_body = params[:response_body]
    @image_failures = []
    stdout_and_log("Syncing LibCal events from #{source_label}")
  end

  def sync
    @updated = @errored = 0

    read_events.each do |raw_event|
      begin
        @log.info("Syncing LibCal Event #{title(raw_event)} on #{start_time(raw_event)}")
        create_or_update_if_needed!(raw_event)
      rescue StandardError => err
        stdout_and_log(%Q(Syncing LibCal Event #{title(raw_event)} errored - #{err.message}\n#{err.backtrace.join("\n")}))
        @errored += 1
      end
    end

    send_image_failures_to_cache
    stdout_and_log("LibCal syncing completed with #{@updated} updated and #{@errored} errored records -- with #{@image_failures.size} image failures.")
  end

  def read_events
    return extract_events(JSON.parse(@response_body)) if @response_body.present?
    raise MissingEventsSourceException, "No LibCal events source configured" if @events_urls.blank?

    @events_urls.flat_map do |source|
      extract_events(JSON.parse(read_response_body(source)))
    end.uniq { |event| event["id"].to_s }
  end

  def record_hash(raw_event)
    normalized_event = normalize_event(raw_event)

    {
      "guid" => guid(normalized_event),
      "title" => title(normalized_event),
      "description" => normalized_event.fetch("description", nil),
      "libcal_categories" => libcal_categories(normalized_event),
      "event_type" => event_type(normalized_event),
      "cancelled" => cancelled(normalized_event),
      "registration_status" => registration_status(normalized_event),
      "registration_link" => registration_link(normalized_event),
      "event_url" => normalized_event.fetch("online_join_url", nil),
      "start_time" => start_time(normalized_event),
      "end_time" => end_time(normalized_event),
      "all_day" => all_day(normalized_event),
      "contact_name" => presenter_name(normalized_event),
      "contact_email" => contact_email(normalized_event),
      "contact_phone" => contact_phone(normalized_event),
      "location_name" => location_name(normalized_event),
      "image_url" => normalized_event.fetch("featured_image", nil),
      "image_alt_text" => normalized_event.fetch("featured_image_alt_text", nil)
    }.compact
     .merge(contact(normalized_event))
     .merge(location(normalized_event))
  end

  def create_or_update_if_needed!(raw_event)
    record = record_hash(raw_event)
    event = Event.find_by(guid: record["guid"]) || Event.new

    event.assign_attributes(record.except("person", "building", "image_url", "image_alt_text", "event_type", "event_url"))
    event.person = record["person"]
    event.building = record["building"]
    # Assign location fields explicitly (not just via assign_attributes) so that a
    # location removed in LibCal clears the stale value instead of persisting it.
    event.space = record["space"]
    event.location_name = record["location_name"]
    event.location_space = record["location_space"]
    event.address = record["address"]
    event.city = record["city"]
    event.state = record["state"]
    event.zip = record["zip"]
    event.libcal_categories = record["libcal_categories"]
    event.event_url = record["event_url"]
    event.event_type = [record["event_type"].presence, ("Online" if record["event_url"].present?)].compact.join(", ").presence

    attach_image(record, event) if record["image_url"].present?
    event.alt_text = record["image_alt_text"] if record["image_alt_text"].present?

    if event.save!
      stdout_and_log(%Q(Successfully saved LibCal record for #{record["title"]}))
      @updated += 1
    else
      stdout_and_log(%Q(LibCal record not saved for #{record["title"]}))
      @errored += 1
    end
  end

  def send_image_failures_to_cache
    result_string = "LibCal image retrieval failure. Please check:<br><br>"
    @image_failures.each do |event|
      result_string += "#{event.title}<br>"
    end

    if @image_failures.size > 0
      Rails.cache.write("events_image_error",
                        result_string,
                        expires_in: 1.hour)
    end
  end

  private

    def fetch_access_token
      token_url = Rails.configuration.libcal_token_url.to_s
      client_id = Rails.configuration.libcal_client_id.to_s
      client_secret = Rails.configuration.libcal_client_secret.to_s

      if token_url.blank? || client_id.blank? || client_secret.blank?
        raise MissingAccessTokenConfigurationException,
          "LibCal token URL, client ID, and client secret must be configured"
      end

      uri = URI.parse(token_url)
      request = Net::HTTP::Post.new(uri)
      request.basic_auth(client_id, client_secret)
      request["Content-Type"] = "application/x-www-form-urlencoded"
      request.set_form_data("grant_type" => "client_credentials")

      response = Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: uri.scheme == "https",
        open_timeout: Rails.configuration.sync_timeout,
        read_timeout: Rails.configuration.sync_timeout
      ) do |http|
        http.request(request)
      end

      payload = JSON.parse(response.body)
      token = payload["access_token"].presence
      return token if response.is_a?(Net::HTTPSuccess) && token.present?

      raise MissingAccessTokenConfigurationException, "Unable to fetch LibCal access token: #{response.code} #{response.body}"
    end

    def read_response_body(source)
      return File.read(source) if File.exist?(source)

      read_remote_response_body(source)
    end

    def read_remote_response_body(source, retry_on_unauthorized: true)
      @access_token = @access_token.presence || fetch_access_token

      URI.open(source, request_options(@access_token)).read
    rescue OpenURI::HTTPError => err
      raise unless retry_on_unauthorized && unauthorized_response?(err)

      @access_token = fetch_access_token
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

    def resolve_event_sources(params)
      explicit_ids = extract_ids(params[:event_ids])
      explicit_sources = Array.wrap(params[:events_urls]).flatten.compact
      explicit_sources << params[:events_url] if params[:events_url].present?

      configured_ids = extract_ids(Rails.configuration.libcal_events_ids)
      configured_sources = sources_from_ids(configured_ids) ||
        Array.wrap(Rails.configuration.libcal_events_url).compact.presence

      sources = sources_from_ids(explicit_ids) || explicit_sources.presence || configured_sources

      Array.wrap(sources)
        .flat_map { |source| source.to_s.split(",") }
        .map(&:strip)
        .reject(&:blank?)
    end

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

    # LibCal's events endpoint caps the `days` query param at 365.
    LIBCAL_MAX_DAYS = 365

    def source_query_params(id)
      start_date = libcal_start_date
      days = [(libcal_end_date - start_date).to_i + 1, LIBCAL_MAX_DAYS].min

      [
        ["cal_id", id],
        ["date", start_date.iso8601],
        ["days", days]
      ]
    end

    def libcal_start_date
      lookback_months = Rails.configuration.libcal_events_lookback_months.to_i
      lookback_months = 6 if lookback_months <= 0

      lookback_months.months.ago.to_date
    end

    def libcal_end_date
      lookahead_months = Rails.configuration.libcal_events_lookahead_months.to_i
      lookahead_months = 12 if lookahead_months <= 0

      lookahead_months.months.from_now.to_date
    end

    def extract_ids(value)
      Array.wrap(value)
        .flat_map { |entry| entry.to_s.split(",") }
        .map(&:strip)
        .reject(&:blank?)
    end

    def contact(raw_event)
      contact_name = presenter_name(raw_event)
      return {} if contact_name.blank? && contact_email(raw_event).blank? && contact_phone(raw_event).blank?

      contact_person = FuzzyFind::Person.find(contact_name.to_s) if contact_name.present?

      if contact_person
        { "person" => contact_person }
      else
        {
          "contact_name" => contact_name,
          "contact_email" => contact_email(raw_event),
          "contact_phone" => contact_phone(raw_event)
        }.compact
      end
    end

    def location(raw_event)
      return {} if location_name(raw_event).blank?

      lookup = location_lookup_for(location_name(raw_event))
      return {} if lookup.blank?

      location_hash = {}
      building = building_for_lookup(lookup)

      if building
        location_hash["building"] = building
      else
        location_hash["location_name"] = lookup_value(lookup, :building)
      end

      location_hash["address"] = lookup_value(lookup, :address)
      location_hash["city"] = lookup_value(lookup, :city)
      location_hash["state"] = lookup_value(lookup, :state)
      location_hash["zip"] = lookup_value(lookup, :zip)

      room = lookup_value(lookup, :space)
      space = space_for_lookup(lookup, building)

      if space
        location_hash["space"] = space
      elsif room.present?
        location_hash["location_space"] = room
      end

      location_hash.compact
    end

    def location_lookup_for(location_name)
      return {} if location_name.blank?

      configured_lookups.find do |key, _value|
        normalize_lookup_key(key) == normalize_lookup_key(location_name)
      end&.last.to_h.with_indifferent_access
    end

    def configured_lookups
      @configured_lookups ||= Rails.configuration.libcal_location_lookup.to_h
    end

    def normalize_lookup_key(value)
      value.to_s.strip.downcase
    end

    def lookup_value(lookup, key)
      lookup&.with_indifferent_access&.[](key)
    end

    def building_for_lookup(lookup)
      building_name = lookup_value(lookup, :building)
      return if building_name.blank?

      Building.where("LOWER(name) = ?", building_name.to_s.strip.downcase).first
    end

    def space_for_lookup(lookup, building)
      return if building.blank?

      space_name = lookup_value(lookup, :space)
      return if space_name.blank?

      building.spaces.where("LOWER(name) = ?", space_name.to_s.strip.downcase).first
    end

    def normalize_event(raw_event)
      raw_event.to_h.deep_stringify_keys
    end

    def guid(raw_event)
      value(raw_event, "id").presence&.to_s || raise(MissingEventIdException, "No LibCal event id found for #{raw_event}")
    end

    def title(raw_event)
      value(raw_event, "title")
    end

    def libcal_categories(raw_event)
      names = category_names(raw_event)
      names.join(", ").presence
    end

    def event_type(raw_event)
      names = Array.wrap(value(raw_event, "event_type"))
                   .flatten
                   .filter_map { |entry| extract_name(entry) }
                   .uniq

      names.join(", ").presence
    end

    def cancelled(raw_event)
      ActiveModel::Type::Boolean.new.cast(value(raw_event, "cancelled"))
    end

    def registration_status(raw_event)
      ActiveModel::Type::Boolean.new.cast(value(raw_event, "registration")) || registration_payload(raw_event).present?
    end

    def registration_link(raw_event)
      registration_value(raw_event, "url") ||
        registration_value(raw_event, "link") ||
        (public_url(raw_event) if registration_status(raw_event))
    end

    def start_time(raw_event)
      parse_time(value(raw_event, "start"))
    end

    def end_time(raw_event)
      parse_time(value(raw_event, "end"))
    end

    def all_day(raw_event)
      ActiveModel::Type::Boolean.new.cast(value(raw_event, "allday"))
    end

    def presenter_name(raw_event)
      value(raw_event, "presenter") ||
        extract_name(value(raw_event, "owner"))
    end

    def contact_email(raw_event)
      value(raw_event, "contact_email")
    end

    def contact_phone(raw_event)
      value(raw_event, "contact_phone")
    end

    def location_name(raw_event)
      extract_name(value(raw_event, "location"))
    end

    def public_url(raw_event)
      url_value(raw_event, "public") || value(raw_event, "url")
    end

    def value(raw_event, key)
      raw_event[key]
    end

    def registration_payload(raw_event)
      value(raw_event, "registration").presence if value(raw_event, "registration").is_a?(Hash)
    end

    def registration_value(raw_event, key)
      registration_payload(raw_event)&.dig(key)
    end

    def url_value(raw_event, key)
      return unless value(raw_event, "url").is_a?(Hash)

      value(raw_event, "url")[key]
    end

    def category_names(raw_event)
      Array.wrap(value(raw_event, "categories") || value(raw_event, "category"))
        .flatten
        .filter_map { |entry| extract_name(entry) }
        .uniq
    end

    def extract_name(entry)
      extracted =
        case entry
        when Hash
          entry["name"] || entry["title"] || entry["category"] || entry["label"]
        else
          entry
        end

      extracted.to_s.strip.presence
    end


    def parse_time(value)
      return if value.blank?

      Time.zone.parse(value.to_s)
    end

    def attach_image(record, event)
      image_to_attach = remote_image(record["image_url"], record["image_alt_text"], event)
      return if image_to_attach.blank?

      io = image_to_attach[:image][:io]
      if io.size >= image_size_limit_bytes
        stdout_and_log("LibCal image for #{event.title.inspect} is #{io.size} bytes, over the #{image_size_limit_bytes}-byte limit; saving event without image")
        @image_failures << event
        return
      end

      event.image.attach(
        io:,
        filename: image_to_attach[:image][:filename],
        metadata: { alt_text: image_to_attach[:metadata][:alt_text] }
      )
    end

    def image_size_limit_bytes
      I18n.t("manifold.default.image_file_size_limit").kilobyte
    end

    def remote_image(image_url, alt_text, event)
      begin
        image_file = download_image_over_ipv4(image_url, event)

        {
          image: {
            io: image_file,
            filename: File.basename(URI.parse(image_url).path).presence || "#{event.guid}.jpg"
          },
          metadata: { alt_text: alt_text.to_s }
        }
      rescue StandardError => e
        stdout_and_log("LibCal image retrieval failure: #{e.message}")
        @image_failures << event
        {}
      end
    end

    def download_image_over_ipv4(image_url, event)
      unless image_url.to_s.match?(%r{\Ahttps?://}i)
        raise ImageDownloadException, "Refusing to download non-HTTP image URL: #{image_url}"
      end

      response = HTTParty.get(
        image_url,
        connection_adapter: Ipv4ConnectionAdapter,
        follow_redirects: true,
        open_timeout: 10,
        read_timeout: 30
      )

      unless response.success?
        raise ImageDownloadException, "Image request for #{image_url} returned #{response.code}"
      end

      file = Tempfile.new(["libcal-event-image-#{event.guid}-", File.extname(URI.parse(image_url).path)])
      file.binmode
      file.write(response.body)
      file.rewind
      file
    end

    def source_label
      @events_urls.presence&.join(", ") || "provided response body"
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      # @stdout.send(level, message)
    end
end
