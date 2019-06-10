# frozen_string_literal: true

require "active_support/concern"

module HasHours
  extend ActiveSupport::Concern

  def get_hours
    LibraryHour.where(location_id: self.hours, date: monday..sunday)
  end

  def get_child_hours
    self.spaces.where.not(hours: nil).map do |location|
      space = [location.label, location.get_hours]
    end
  end

  def monday(date_param = nil)
    date_param ? date_param.beginning_of_week : Date.today.beginning_of_week
  end

  def sunday(date_param = nil)
    date_param ? date_param.end_of_week + 1 : Date.today.end_of_week + 1
  end
end
