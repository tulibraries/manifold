# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

class SyncService::Events
  class MissingGuidException < StandardError; end

  def self.call(events_url: nil, force: false)
    new(events_url:, force:).sync
  end

  def initialize(params = {})
    @log = Logger.new("log/sync-event.log")
    @stdout = Logger.new(STDOUT)
    @eventsUrl = params.fetch(:events_url) || Rails.configuration.events_feed_url
    @force = params.fetch(:force, false)
    @eventsDoc = Nokogiri::XML(URI.open(@eventsUrl))
    @image_failures = []
    stdout_and_log("Syncing events from #{@eventsUrl}")
  end

  def sync
    @updated = @skipped = @errored = 0
    read_events.each do |event|
      begin
        @log.info(%Q(Syncing Event #{event["Title"]} on #{event["EventStartDate"]}))
        record = record_hash(event)
        create_or_update_if_needed!(record)
      rescue Exception => err
        stdout_and_log(%Q(Syncing Event #{event["Title"]} errored -  #{err.message} \n #{err.backtrace}))
        @errored += 1
      end
    end
    send_image_failures_to_cache
    stdout_and_log("Syncing completed with #{@updated} updated, #{@skipped} skipped, and #{@errored} errored records -- with #{@image_failures.size} image failures.")
  end

  def send_image_failures_to_cache
    result_string = "Image retrieval failure. Please check:<br><br>"
    @image_failures.each do |event|
      result_string += "#{event.title}<br>"
    end
    if @image_failures.size > 0
      Rails.cache.write('events_image_error', 
                        result_string, 
                        expires_in: 1.hour)
    end
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
      "image_xml"           => event.fetch("Image", nil),
      "start_time"          => start_time(event),
      "end_time"            => end_time(event),
      "all_day"             => all_day(event)
    }
      .merge(contact(event))
      .merge(location(event))
  end

  def create_or_update_if_needed!(record)
    event = Event.find_by(guid: record["guid"])
    event = event ? event : Event.new
    event.assign_attributes(record.except("person", "building", "image", "image_xml", "path"))
    event.person = record["person"]
    event.building = record["building"]
    event.tags = record["tags"]
    event.event_type = record["event_type"]
    event.event_url = record["event_url"]
    event.event_type += ", Online" if event.event_url.present?

    record["image_xml"].present? ? attach_image(record, event) : event.image

    if event.save!
      stdout_and_log(%Q(Successfully saved record for #{record["title"]}))
      @updated += 1
    else
      stdout_and_log(%Q(Record not saved for #{record["title"]}))
      @updated += 1
    end
  end

  def attach_image(record, event)
    image_to_attach = event_image(record["image_xml"], event)
    event.image.attach(
      io: image_to_attach[:image][:io],
      filename: image_to_attach[:image][:filename]
    ) if image_to_attach.present?
  end

  def event_image(image_xml, event)
    if image_xml
      img = Nokogiri.XML(image_xml).xpath("//img")
      image_path = img.attribute("src")&.value || ""
      begin
        {
          image: { io: URI.open("#{image_path}"),
          filename: image_path.split("/thumbnail/")&.second&.split("?").first.gsub("%20", "_") },
          alt_text: img.attribute("alt")&.value
        }
      rescue => e
        stdout_and_log("Image retrieval failure: #{e.message}")
        @image_failures << event
        {}
      end
    else
      {}
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
      if event["LocationUnaffiliated"].present?
        location_hash["external_building"] = event.fetch("LocationUnaffiliated") { nil }
        location_hash["external_address"] = event.fetch("AddressUnaffiliated") { nil }
        location_hash["external_city"] = event.fetch("CityUnaffiliated") { nil }
        location_hash["external_state"] = event.fetch("StateUnaffiliated") { nil }
        location_hash["external_zip"] = event.fetch("ZipUnaffiliated") { nil }
      else
        location_hash["external_building"] = event.fetch("Location") { nil }
        location_hash["external_address"] = event.fetch("Address") { nil }
        location_hash["external_city"] = event.fetch("City") { nil }
        location_hash["external_state"] = event.fetch("State") { nil }
        location_hash["external_zip"] = event.fetch("Zip") { nil }
      end
    end

    room = event.fetch("Room", nil)
    space = (FuzzyFind::Space.find(room.to_s, addl_attribute: { building: }) if building) || nil

    if space
      location_hash["space"] = space
    else
      location_hash["external_space"] = room || nil
    end
    location_hash
  end

  def stdout_and_log(message, level: :info)
    @log.send(level, message)
    # @stdout.send(level, message)
  end
end
