# frozen_string_literal: true

require "open-uri"

class SyncService::Events
  def self.call(events_url: nil)
    new(events_url: events_url).sync
  end

  def initialize(params = {})
    @eventsUrl = params.fetch(:events_url) || Rails.configuration.events_feed_url
    @eventsDoc = Nokogiri::XML(open(@eventsUrl))
  end

  def sync
    read_events.each do |e|
      record = record_hash(e)
      create_or_update_if_needed!(record)
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
      "title" => event.fetch("Title", I18n.t("fortytude.default.event.title")),
      "description" => event.fetch("Description",  I18n.t("fortytude.default.event.description")),
      "tags" => event.fetch("Tags", nil),
      "cancelled" => event.fetch("Canceled", 0),
      "registration_status" => event.fetch("RegistrationStatus", I18n.t("fortytude.default.event.registration_status")),
      "registration_link" => event.fetch("RegistrationLink", nil),
      "start_time" => start_time(event),
      "end_time" => end_time(event),
      "all_day" => all_day(event),
      "content_hash" => xml_hash(event)
    }
      .merge(contact(event))
      .merge(location(event))
      .merge(event_image(event))
  end

  def create_or_update_if_needed!(record_hash)
    # If a record already exists with this content hash, then no update needed
    unless Event.exists?(content_hash: record_hash["content_hash"])
      # Fuzzy find record based on title and start time, and otherwise create a new one
      event = FuzzyFind::Event.find(
        record_hash["title"],
        addl_attribute: { start_time: record_hash["start_time"] }
        ) || Event.new
      event.assign_attributes(record_hash.except("person", "building", "image"))
      event.person = record_hash["person"]
      event.building = record_hash["building"]
      event.tags = record_hash["tags"]
      unless (record_hash[:image].nil? || event.image.attached?)
        event.image.attach(
          io: record_hash[:image][:io],
          filename: record_hash[:image][:filename]
        )
      end
      event.save!
    end
  end


  def start_time(event)
    Time.parse(
      event.values_at("EventStartDate", "EventStartTime").join(" ")
      ).to_s
  end

  def end_time(event)
    Time.parse(
      event.values_at("EventEndDate", "EventEndTime").join(" ")
      ).to_s
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
        "external_contact_name"  => contact_name || I18n.t("fortytude.default.event.contact_name"),
        "external_contact_email" => event.fetch("ContactEmail") { I18n.t("fortytude.default.event.contact_email") },
        "external_contact_phone" => event.fetch("ContactPhone") { I18n.t("fortytude.default.event.contact_phone") }
      }
    end
  end

  def location(event)
    location_hash = {}

    location = event.fetch("Location", nil)
    building = FuzzyFind::Building.find(location.to_s)

    if building
      location_hash["building"] = building
    else
      location_hash["external_building"] = location || I18n.t("fortytude.default.event.building")
      location_hash["external_address"] = event.fetch("Address") { I18n.t("fortytude.default.event.external_address") }
      location_hash["external_city"] = event.fetch("City") { I18n.t("fortytude.default.event.external_city") }
      location_hash["external_state"] = event.fetch("State") { I18n.t("fortytude.default.event.external_state") }
      location_hash["external_zip"] = event.fetch("Zip") { I18n.t("fortytude.default.event.external_zip") }
    end

    room = event.fetch("Room", nil)
    space = (FuzzyFind::Space.find(room.to_s, addl_attribute: { building: building }) if building) || nil

    if space
      location_hash["space"] = space
    else
      location_hash["external_space"] = room || I18n.t("fortytude.default.event.space")
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
            io: open(image_path),
            filename: image_path.split("/thumbnail/")&.second&.split("?").first.gsub("%20", "_")
          },
        alt_text: img.attribute("alt")&.value
      }

    else
      {}
    end
  end
end
