# frozen_string_literal: true

require "active_support/concern"

module SetDates
  extend ActiveSupport::Concern
  @today = Time.zone.today.strftime("%Y-%m-%d 00:00:00")
  @todays_date = @today.to_date.strftime("%^A, %^B %d, %Y ")

  def todays_hours
    if self.hours.present?
      LibraryHour.where(location_id: self.hours, date: @today).pluck(:hours).first
    end
    if self.hours.blank?
      if self.space.hours.present?
        LibraryHour.where(location_id: self.building.hours, date: @today).pluck(:hours).first
      else
        LibraryHour.where(location_id: self.space.hours, date: @today).pluck(:hours).first
      end
    end
  end
end
