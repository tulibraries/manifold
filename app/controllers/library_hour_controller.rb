# frozen_string_literal: true

class LibraryHoursController < ApplicationController
  before_action :buildings, :set_dates, only: [:index]

  def index
    @buildings.each do |building|
      building[:spaces].map! do |space|
        space = [building[:slug], LibraryHour.where(location_id: space, date: @monday..@sunday + 1)]
      end
    end
  end

  def set_dates
    @today = Time.zone.today
    @date_picker_date = params[:date] ? params[:date] : @today
    begin
      @date = params[:date].nil? ? @today : Date.parse(params[:date])
    rescue ArgumentError
      @date = @today
    end

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

  def buildings
    @buildings = [
      {
        slug: "charles",
        spaces: [
                  "charles",
                  "24-7",
                  "asrs",
                  "guest_computers",
                  "scholars_studio",
                  "service_zone",
                  "scrc",
                  "cafe",
                  "exhibits"
                ]
      },
      {
        slug: "ambler",
        spaces: ["ambler"]
      },
      {
        slug: "blockson",
        spaces: ["blockson"]
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
        slug: "online",
        spaces: ["ask_a_librarian"]
      }
    ]
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
