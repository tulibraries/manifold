class LibraryHoursController < ApplicationController

  def index
    @library_hours = LibraryHours.all
    @locations = LibraryHours.all.pluck(:location,:location_id).uniq
  end
  def show
    @library_hours = LibraryHours.all
    @today = Date.today
    @hours = LibraryHours.where('location_id = ?', params[:id])
    five = Array.new
    @hours.each do |hour|
      unless hour.date.to_date < @today
        five.push(hour)
      end
    end
    @five = five[0,5]
    @location = Building.where('hours = ?', params[:id])
    binding.pry
  end


end
