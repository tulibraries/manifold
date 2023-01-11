# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

class SyncService::Events
  class MissingGuidException < StandardError; end

  def self.call(events_url: nil, force: false)
    new(events_url: events_url, force: force).sync
  end

  def initialize(params = {})
    @log = Logger.new("log/sync-event.log")
    @stdout = Logger.new(STDOUT)
    @eventsUrl = params.fetch(:events_url) || Rails.configuration.events_feed_url
    @force = params.fetch(:force, false)
    # @eventsDoc = Nokogiri::XML(URI.open(@eventsUrl, { read_timeout: Rails.configuration.sync_timeout }))
    # ruby 3.1.2 -- options hash no longer works: "no implicit conversion of Hash into String"
    @eventsDoc = Nokogiri::XML(URI.open(@eventsUrl))
    stdout_and_log("Syncing events from #{@eventsUrl}")
  end

  def sync
    @updated = @skipped = @errored = 0
    read_events.each do |e|
      begin
        @log.info(%Q(Syncing Event #{e["Title"]} on #{e["EventStartDate"]}))
        record = record_hash(e)
        create_or_update_if_needed!(record)
      rescue Exception => err
        stdout_and_log(%Q(Syncing Event #{e["Title"]} errored -  #{err.message} \n #{err.backtrace}))
        @errored += 1
      end
    end
    stdout_and_log("Syncing completed with #{@updated} updated, #{@skipped} skipped, and #{@errored} errored records.")
  end

  def read_events
    @eventsDoc.xpath("//Events/Event").map do |event|
      event_xml = event.to_xml
      Hash.from_xml(event_xml)["Event"].merge(xml: event_xml)
    end
  end

  def record_hash(event)
    {
      "guid"                => event.fetch("GUID") { raise MissingGuidException.new("No GUID found for event #{event}") },
      "title"               => event.fetch("Title", nil),
      "description"         => event.fetch("Description", nil),
      "tags"                => event.fetch("Tags", nil),
      "path"                => event.fetch("Path", nil),
      "event_type"          => event.fetch("Type", nil),
      "cancelled"           => event.fetch("Canceled", 0),
      "registration_status" => event.fetch("RegistrationStatus", nil),
      "registration_link"   => event.fetch("ExternalRegistrationURL", nil),
      "event_url"           => event.fetch("OnlineEventHostUrl", nil),
      "start_time"          => start_time(event),
      "end_time"            => end_time(event),
      "all_day"             => all_day(event),
      "content_hash" => xml_hash(event)
    }
      .merge(contact(event))
      .merge(location(event))
      .merge(event_image(event))
  end

  def create_or_update_if_needed!(record_hash)
    # If a record already exists with this content hash, then no update needed
    if should_create_or_update(record_hash)
      event = Event.find_by(content_hash: record_hash["content_hash"]) || Event.find_by(guid: record_hash["guid"])
      if event
        stdout_and_log(
          %Q(Incoming event with title #{record_hash["title"]} matched to existing event (id = #{event.id} ) with title #{event.title}), level: :debug
        )
      else
        event = Event.new
      end
      event.assign_attributes(record_hash.except("person", "building", "image", "path"))
      event.person = record_hash["person"]
      event.building = record_hash["building"]
      event.tags = record_hash["tags"]
      event.event_type = record_hash["event_type"]
      event.event_url = record_hash["event_url"]
      event.event_type += ", Online" unless event.event_url.nil?
      unless (record_hash[:image].nil? || event.image.attached?)
        event.image.attach(
          io: record_hash[:image][:io],
          filename: record_hash[:image][:filename]
        )
      end
      if event.save!
        stdout_and_log(%Q(Successfully saved record for #{record_hash["title"]}))
        @updated += 1
      else
        stdout_and_log(%Q(Record not saved for #{record_hash["title"]}))
        @updated += 1
      end
    else
      stdout_and_log(%Q(Found match for content hash for #{record_hash["title"]}; skipped syncing.))
      @skipped += 1
    end
  end

  def start_time(event)
    unless all_day(event)
      Time.zone.parse(event.values_at("EventStartDate", "EventStartTime").join(" ")).to_s
    end
  end

  def end_time(event)
    unless all_day(event)
      Time.zone.parse(event.values_at("EventEndDate", "EventEndTime").join(" ")).to_s
    end
  end

  def all_day(event)
    event["EventStartTime"].include?("All day")
  end

  def xml_hash(event)
    Digest::SHA1.hexdigest(
      event.fetch(:xml) { raise StandardError.new("No Event XML supplied") }
    )
  end

  def contact(event)
    contact_name = event.fetch("ContactName")
    contact_person = FuzzyFind::Person.find(contact_name.to_s)
    if contact_person
      { "person" => contact_person }
    else
      {
        "external_contact_name"  => contact_name || nil,
        "external_contact_email" => event.fetch("ContactEmail") { nil },
        "external_contact_phone" => event.fetch("ContactPhone") { nil }
      }
    end
  end

  def location(event)
    location_hash = {}

    location = event.fetch("Location", nil)
    address = event.fetch("Address", nil)

    building = FuzzyFind::Building.find(
      location.to_s,
        addl_attribute: { address1: address.to_s }
        )

    if building
      location_hash["building"] = building
    else
      location_hash["external_building"] = event.fetch("LocationUnaffiliated") { nil }
      location_hash["external_address"] = event.fetch("AddressUnaffiliated") { nil }
      location_hash["external_city"] = event.fetch("CityUnaffilaited") { nil }
      location_hash["external_state"] = event.fetch("StateUnaffiliated") { nil }
      location_hash["external_zip"] = event.fetch("ZipUnaffiliated") { nil }
    end

    room = event.fetch("Room", nil)
    space = (FuzzyFind::Space.find(room.to_s, addl_attribute: { building: building }) if building) || nil

    if space
      location_hash["space"] = space
    else
      location_hash["external_space"] = room || nil
    end
    location_hash
  end

  def event_image(event)
    image_xml = event.fetch("Image", nil)
    if image_xml
      img = Nokogiri.XML(image_xml).xpath("//img")
      image_path = img.attribute("src")&.value || ""

      {
        image:
          {
            io: URI.open(image_path),
            filename: image_path.split("/thumbnail/")&.second&.split("?").first.gsub("%20", "_")
          },
        alt_text: img.attribute("alt")&.value
      }

    else
      {}
    end
  end

  def already_exists?(record_hash)
    Event.exists?(content_hash: record_hash["content_hash"])
  end

  def does_not_exist?(record_hash)
    !already_exists?(record_hash)
  end

  def should_create_or_update(record_hash)
    (does_not_exist?(record_hash) || @force)
  end

  def stdout_and_log(message, level: :info)
    @log.send(level, message)
    # @stdout.send(level, message)
  end
end
