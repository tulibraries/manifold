# frozen_string_literal: true

module EventFilters
  extend ActiveSupport::Concern

  def types_list(events)
    to_add = events.select { |event| event.event_type { |type| type == params[:type] } }

    types = to_add.map { |event| event.event_type }

    types.uniq.sort
  end

  def locations_list(events)
    to_add = events.select { |event| event.building == params[:location] || event.external_building == params[:location] }

    locations = to_add.map { |event|
      unless event.building.nil?
        event.building.label
      else
        event.external_building
      end }

    locations.uniq.sort
  end
end
