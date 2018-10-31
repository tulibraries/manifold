# frozen_string_literal: true

class LibraryHoursController < ApplicationController
  def index
    @locations = LibraryHours.all.pluck(:location_id).uniq
  end
  def show
    @locations = LibraryHours.distinct.pluck(:location_id)
    @today = Date.today
    sunday = @today.beginning_of_week - 1
    saturday = @today.end_of_week

    @location = Building.where(hours: params[:id])
    if @location.blank?
      @location = Space.where(hours: params[:id])
    end
    if @location.blank?
      @location = Service.where(hours: params[:id])
    end

    @hours = LibraryHours.where(location_id: params[:id])
    @seven = LibraryHours.where(location_id: params[:id], date: sunday..saturday)
  end
end
