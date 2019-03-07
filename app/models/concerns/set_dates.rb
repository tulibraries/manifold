# frozen_string_literal: true

require "active_support/concern"

module SetDates
  extend ActiveSupport::Concern
  @today = Date.today.strftime("%Y-%m-%d 00:00:00")
  @todays_date = @today.to_date.strftime("%^A, %^B %d, %Y ")

  def todays_hours
    unless self.hours.blank?
      LibraryHours.where(location_id: self.hours, date: @today).pluck(:hours).first
    end
    if self.hours.blank?
      unless self.space.hours.blank?
        LibraryHours.where(location_id: self.building.hours, date: @today).pluck(:hours).first
      else
        LibraryHours.where(location_id: self.space.hours, date: @today).pluck(:hours).first
      end
    end
  end
end
