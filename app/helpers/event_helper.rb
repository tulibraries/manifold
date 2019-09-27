# frozen_string_literal: true

require "json/ld"

module EventHelper
  def filter_tags_events
    tags = []
    unless params[:type].nil?
      types = params[:type].split(",")
      types.each do |type|
        tags << "#{type}&nbsp;<a href=\"#{events_path(request.query_parameters.except(:type).merge(page: 1))}\">X</a>"
      end
    end
    unless params[:location].nil?
      locations = params[:location].split(",")
      locations.each do |location|
        tags << "#{location}&nbsp;<a href=\"#{events_path(request.query_parameters.except("," + location).merge(page: 1))}\">X</a>"
      end
    end
    tags
  end

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

    if event.building
      event_hash["location"] ||= {}
      event_hash["location"]["@type"] = "Place"
      event_hash["location"]["name"] = event.building.name
    elsif event.attributes.has_key?("external_building")
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
  def get_bldg_name(bldg_name)
    unless bldg_name.nil?
      t("manifold.default.event.#{bldg_name.parameterize.underscore}", default: bldg_name)
    end
  end
end
