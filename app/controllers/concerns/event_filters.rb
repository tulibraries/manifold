# frozen_string_literal: true

module EventFilters
  extend ActiveSupport::Concern

  def dates_list(events)
    to_add = events.select { |event| event if event.start_time.strftime("%Y-%m-%d") == params[:date] }

    dates = to_add.map { |event|
      unless event.start_time.nil?
        event
      end
    }
    dates.compact.uniq.sort
  end
end
