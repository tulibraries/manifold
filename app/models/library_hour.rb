# frozen_string_literal: true

class LibraryHour < ApplicationRecord
  validates :location_id, :date, :hours, presence: true

  belongs_to :building, optional: true
  belongs_to :space, optional: true
  belongs_to :service, optional: true

  def self.today
    Time.now.strftime("%Y-%m-%d").in_time_zone
  end

  def self.todays_hours_at(loc)
    find_by(location_id: loc, date: today)
  end
end
