# frozen_string_literal: true

module EventFilters
  extend ActiveSupport::Concern

  def types_list(events)
    to_add = events.select { |event| event.get_types.try(:any?) }.collect { |type| type.event_type.split(",") }
    types = []
    to_add.map { |type| type.each do |t| types << t.strip end }
    types.flatten.compact.uniq.sort
  end

  def all_types(events)
    to_add = events.select { |event| event.get_types.try(:any?) }.collect { |type| type.event_type.split(",") }
    types = []
    to_add.map { |type| type.each do |t| types << t.strip end }
    types.compact.flatten.uniq.sort
  end

  def dates_list(events)
    to_add = events.select { |event| event.start_time == params[:date] }

    dates = to_add.map { |event|
      unless event.start_time.nil?
        event.start_time
      end
    }
    dates.compact.uniq.sort
  end
end
