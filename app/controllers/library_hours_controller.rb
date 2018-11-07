# frozen_string_literal: true

class LibraryHoursController < ApplicationController
  before_action :get_locations, only: [:index, :show]
  before_action :set_location, only: [:show]
  before_action :set_dates, only: [:index, :show]

  def index
    @all_hours = Array.new
    locations = [
      "paley",
      "media",
      "doc_del",
      "ref_desk",
      "v_ref",
      "thinktank",
      "scrc",
      "dsc",
      "guest_computers",
      "ambler",
      "ginsburg",
      "innovation",
      "podiatry",
      "blockson",
    ] 
    locations.map { |x| 
      if ["paley","media","doc_del","ref_desk","v_ref","thinktank","scrc","dsc","scrc","guest_computers"].include?(x) {
        @hours = {"paley" => [x, LibraryHours.where(location_id: x, date: @sunday..@saturday)]}
        @paley_hours.push(@hours)
      }
      elsif ["ginsburg","podiatry","innovation"].include?(x) {
        @hours = {"hsl" => [x, LibraryHours.where(location_id: x, date: @sunday..@saturday)]}
        @hsl_hours.push(@hours)
      }
      elsif ["ambler"].include?(x) {
        hours = {"ambler" => [x, LibraryHours.where(location_id: x, date: @sunday..@saturday)]}
        @ambler_hours.push(@hours)
      }
      elsif ["blockson"].include?(x) {
        hours = {"blockson" => [x, LibraryHours.where(location_id: x, date: @sunday..@saturday)]}
        @blockson_hours.push(@hours)
      }
      end
      @all_hours = @paley_hours + @hsl_hours + @ambler_hours + @blockson_hours
    }
  end
  def show
    @hours = LibraryHours.where(location_id: params[:id])
    @seven = LibraryHours.where(location_id: params[:id], date: @sunday..@saturday)
  end

  def set_dates
    @today = Date.today
    @sunday = @today.beginning_of_week - 1
    @saturday = @today.end_of_week
  end

  def set_location
    @location = Building.where(hours: params[:id])
    if @location.blank?
      @location = Space.where(hours: params[:id])
    end
    if @location.blank?
      @location = Service.where(hours: params[:id])
    end
  end

  def get_locations
    @locatio = LibraryHours.distinct.pluck(:location_id)
  end
end
