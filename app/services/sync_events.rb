# frozen_string_literal: true

require "open-uri"
require "nokogiri"
require "pry"

class SyncEvents
  def initialize(params = [])
    @eventsUrl = params.fetch(:events_url, "https://events.temple.edu/feed/xml/events?department=2566")
    @eventsDoc = ""
  end

  def read_events
    @eventsDoc = Nokogiri::XML(open(@eventsUrl))
    events = @eventsDoc.xpath("//Events/Event").map
    @events = events.map do |e|
      event = Hash.new
      e.elements.each do |ele|
        event[ele.name] = ele.content
      end
      event
    end
  end

  def record_hash(event)
    event_hash = {
      "title" => event.fetch("Title", I18n.t("fortytude.default.event.title")),
      "description" => event.fetch("Description",  I18n.t("fortytude.default.event.description")),
      "cancelled" => event.fetch("Canceled", 0),
      "registration_status" => event.fetch("RegistrationStatus", I18n.t("fortytude.default.event.registration_status")),
      "registration_link" => event.fetch("RegistrationLink", "#"),
    }

    start_time = [event.fetch("EventStartDate", ""), event.fetch("EventStartTime", "")].join(" ")
    event_hash["start_time"] = Time.parse("#{start_time}").to_s

    end_time = [event.fetch("EventEndDate", ""), event.fetch("EventEndTime", "")].join(" ")
    event_hash["end_time"] = Time.parse("#{end_time}").to_s

    contact_name = event.fetch("ContactName") { I18n.t("fortytude.default.event.contact_name") }
    contact_person = FuzzyFinderService.call(
      needle: contact_name,
      haystack_model: Person,
      attribute: :name)
    unless contact_person.nil?
      event_hash["person"] = contact_person
    else
      event_hash["external_contact_name"]  = contact_name
      event_hash["external_contact_email"] = event.fetch("ContactEmail") { I18n.t("fortytude.default.event.contact_email") }
      event_hash["external_contact_phone"] = event.fetch("ContactPhone") { I18n.t("fortytude.default.event.contact_phone") }
    end

    location = event.fetch("Location") { I18n.t("fortytude.default.event.building") }
    building = FuzzyFinderService.call(
      needle: location,
      haystack_model: Building,
      attribute: :name)
    unless building.nil?
      event_hash["building"] = building
    else
      event_hash["external_building"] = location
      event_hash["external_address"] = event.fetch("Address") { I18n.t("fortytude.default.event.external_address") }
      event_hash["external_city"] = event.fetch("City") { I18n.t("fortytude.default.event.external_city") }
      event_hash["external_state"] = event.fetch("State") { I18n.t("fortytude.default.event.external_state") }
      event_hash["external_zip"] = event.fetch("Zip") { I18n.t("fortytude.default.event.external_zip") }
    end

    room = event.fetch("Room") { I18n.t("fortytude.default.event.space") }
    space = FuzzyFinderService.call(
      needle: room,
      haystack_model: Space,
      attribute: :name)
    unless space.nil?
      event_hash["space"] = space
    else
      event_hash["external_space"] = room
    end

    event_hash["content_hash"] = Digest::SHA1.hexdigest(event.to_xml)

    event_hash
  end

  def sync
    events = read_events
    events.each do |e|
      params = record_hash(e)
      event = Event.create(params.except ["person", "building"])
      event.person = params["person"]
      event.building = params["building"]
      event.save!
    end
  end
end
