class LibraryHoursController < ApplicationController

  def index
    @library_hours = LibraryHours.all
    @locations = LibraryHours.all.pluck(:location,:location_id).uniq
  end
  def show
    @library_hours = LibraryHours.all
    @today = Date.today
    @hours = LibraryHours.where('location_id = ?', params[:id])
    seven = Array.new
    @hours.each do |hour|
      unless hour.date.to_date < @today
        seven.push(hour)
      end
    end
    @seven = seven[0,7]
    #binding.pry
    @location = Building.where('hours = ?', params[:id])
  end


end
