class LibraryHoursController < ApplicationController

  def index
    @library_hours = LibraryHours.all
    @locations = LibraryHours.all.pluck(:location,:location_id).uniq
  end
  def show
    @library_hours = LibraryHours.all
    @today = Date.today
    @hours = LibraryHours.where('location_id = ?', params[:id])

    sunday = Date.today.beginning_of_week - 1
    saturday = Date.today.end_of_week - 1

    @week = (sunday..saturday).to_a

    seven = Array.new

    @hours.each do |hour|
      if hour.date.to_date >= sunday && hour.date.to_date <= saturday
        seven.push(hour)
      end
    end

    @seven = seven[0,7]
    @location = Building.where('hours = ?', params[:id])
  end


end
