# frozen_string_literal: true

class SyncService::Libcal::LocationResolver
  def resolve(location_name)
    return {} if location_name.blank?

    lookup = lookup_for(location_name)
    return {} if lookup.blank?

    location_hash = {}
    building = building_for(lookup)

    if building
      location_hash["building"] = building
    else
      location_hash["location_name"] = lookup[:building]
    end

    location_hash["address"] = lookup[:address]
    location_hash["city"] = lookup[:city]
    location_hash["state"] = lookup[:state]
    location_hash["zip"] = lookup[:zip]

    room = lookup[:space]
    space = space_for(lookup, building)

    if space
      location_hash["space"] = space
    elsif room.present?
      location_hash["location_space"] = room
    end

    location_hash.compact
  end

  private

    def lookup_for(location_name)
      configured_lookups.find do |key, _value|
        normalize_key(key) == normalize_key(location_name)
      end&.last.to_h.with_indifferent_access
    end

    def configured_lookups
      @configured_lookups ||= Rails.configuration.libcal_location_lookup.to_h
    end

    def normalize_key(value)
      value.to_s.strip.downcase
    end

    def building_for(lookup)
      building_name = lookup[:building]
      return if building_name.blank?

      Building.where("LOWER(name) = ?", building_name.to_s.strip.downcase).first
    end

    def space_for(lookup, building)
      return if building.blank?

      space_name = lookup[:space]
      return if space_name.blank?

      building.spaces.where("LOWER(name) = ?", space_name.to_s.strip.downcase).first
    end
end
