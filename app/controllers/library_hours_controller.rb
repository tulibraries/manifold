class LibraryHoursController < ApplicationController

  def index
    @locations = LibraryHours.all.pluck(:location_id).uniq
  end
  def show
    @locations = LibraryHours.all.pluck(:location_id).uniq
    @today = Date.today
    sunday = @today.beginning_of_week - 1
    saturday = @today.end_of_week 

    @location = Building.where(hours: params[:id])
    if @location.nil?
      @location = Space.where(hours: params[:id])
    end
    # if @location.nil?
    #   @location = Service.where(hours: params[:id])
    # end
    @hours = LibraryHours.where(location_id: params[:id])
    @seven = LibraryHours.where(location_id: params[:id], date: sunday..saturday)
  end

end