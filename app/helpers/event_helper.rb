# frozen_string_literal: true

require "json/ld"

module EventHelper
  def json_ld(event)
    event_hash = {}
    event_hash["@context"] = "http://schema.org"
    event_hash["@type"] = "Event"
    event_hash["eventStatus"] = "http://schema.org/EventCancelled" if event["cancelled"]
    event_hash["name"] = event[:title]
    event_hash["description"] = strip_tags(event[:description])
    unless event_hash["all_day"]
      event_hash["startTime"] = event[:start_time] unless event[:start_time].nil?
      event_hash["endTime"] = event[:end_time] unless event[:end_time].nil?
    end

    building = Building.find(event[:building_id])
    unless building.nil?
      event_hash["location"] = {}
      event_hash["location"]["@type"] = "Place"
      event_hash["location"]["name"] = building.name
    end
    if event["external_building"]
      event_hash["location"] = {}
      event_hash["location"]["@type"] = "Place"
      event_hash["location"]["name"] = event[:external_building]
      event_hash["location"]["address"] = {}
      event_hash["location"]["address"]["@type"] = "PostalAddress"
      event_hash["location"]["address"]["streetAddress"] = event[:external_address]
      event_hash["location"]["address"]["addressLocality"] = event[:external_city]
      event_hash["location"]["address"]["addressRegion"] = event[:external_state]
      event_hash["location"]["address"]["postalCode"] = event[:external_zip]
    end

    event_rdf = JSON.parse event_hash.to_json
    raw(event_rdf.to_json)
  end
end
