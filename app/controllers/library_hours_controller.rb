# frozen_string_literal: true

class LibraryHoursController < ApplicationController
  before_action :get_locations, :set_dates, only: [:index]

  def index
    @buildings = [
      {
        slug: "charles",
        spaces: [
                  "charles",
                  "service_zone",
                  "cafe",
                  "scrc",
                  "scholars_studio",
                  "success_center",
                  "ask_a_librarian",
                  "asrs",
                  "guest_computers"
                ]
      },
      {
        slug: "ginsburg",
        spaces: ["ginsburg", "innovation"]
      },
      {
        slug: "podiatry",
        spaces: ["podiatry"]
      },
      {
        slug: "ambler",
        spaces: ["ambler"]
      },
      {
        slug: "blockson",
        spaces: ["blockson"]
      }
    ]
    @buildings.each do |building|
      building.values.second.map! do |space|
        space = [building.values.first, LibraryHour.where(location_id: space, date: @monday..@sunday + 1)]
      end
    end
  end

  def set_dates
    @today = Date.today
    @date = params[:date].nil? ? @today : Date.parse(params[:date])

    unless params[:date].nil?
      @monday = @date.beginning_of_week
      @sunday = @date.end_of_week
      @next_week = @date.next_week
      @last_week = @date.prev_week
    else
      @monday = @today.beginning_of_week
      @sunday = @today.end_of_week
      @next_week = @today.next_week
      @last_week = @today.prev_week
    end
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
    @location = LibraryHour.distinct.pluck(:location_id)
  end

  def build_hours_data_structure(input)
    input.map do |building|
      building[:spaces].map! do |space|
        { slug: space, hours: LibraryHour.where(location_id: space, date: @monday..@sunday) }
      end
      building
    end
  end
end
