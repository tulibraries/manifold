# frozen_string_literal: true

# One-time data backfill (not part of the ongoing sync): link legacy events —
# mostly from the previous sync service — to managed Building/Space records using
# the LibCal location crosswalk. Events synced from the LibCal feed already get
# their building/space resolved during the sync itself, so this only fixes the
# historical backlog that the feed no longer includes.
#
#   rake libcal:backfill_locations
namespace :libcal do
  desc "one-time: backfill building/space associations on legacy events from the LibCal location crosswalk"
  task backfill_locations: :environment do
    crosswalk = Rails.configuration.libcal_location_lookup.to_h
    updated = 0

    Event.where(building_id: nil).where.not(location_name: [nil, ""]).find_each do |event|
      name = event[:location_name].to_s.strip

      building = Building.where("LOWER(name) = ?", name.downcase).first
      space = nil

      unless building
        entry = crosswalk.find { |key, _| key.to_s.strip.downcase == name.downcase }&.last&.to_h
        next if entry.blank?

        entry = entry.with_indifferent_access
        building = Building.where("LOWER(name) = ?", entry[:building].to_s.strip.downcase).first
        next if building.blank?

        space = building.spaces.where("LOWER(name) = ?", entry[:space].to_s.strip.downcase).first if entry[:space].present?
      end

      event.building = building
      event.space = space if space
      event.save!
      updated += 1
    end

    puts "Backfilled building associations for #{updated} event(s)."
  end
end
