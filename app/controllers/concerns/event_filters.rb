# frozen_string_literal: true

module EventFilters
  extend ActiveSupport::Concern

  def types_list(events)
    to_add = events.select { |event| event.get_types.try(:any?) }.collect { |type| type.event_type.split(",") }

    types = to_add.map { |type| if type.include?(params[:type])
                                  type.each do |t| 
                                    t.strip!
                                  end
                                end }

    types.compact.flatten.uniq.sort
  end

  def all_types(events)
    to_add = events.select { |event| event.get_types.try(:any?) }.collect { |type| type.event_type.split(",") }
    
    types = to_add.map { |type| type.each do |t| 
                                t.strip!
                                end }

    types.compact.flatten.uniq.sort
  end

  def locations_list(events)
    to_add = events.select { |event| event.building == params[:location] || event.external_building == params[:location] }

    locations = to_add.map { |event|
      unless event.building.nil?
        event.building.label
      else
        unless event.external_building.nil?
          event.external_building
        end
      end }

    locations.compact.uniq.sort
  end
end
