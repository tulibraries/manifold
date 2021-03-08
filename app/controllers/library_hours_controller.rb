# frozen_string_literal: true

class LibraryHoursController < ApplicationController
  before_action :buildings, :set_dates, only: [:index, :show]

  def show
    redirect_to action: "index"
  end

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
        slug: "online",
        spaces: ["ask_a_librarian"]
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
        slug: "charles",
        spaces: [
                  "charles",
                  "service_zone",
                  "scrc",
                  "scholars_studio",
                  "asrs",
                  "guest_computers",
                  "cafe",
                  "24-7"
                ]
      },
      {
        slug: "ginsburg",
        spaces: ["ginsburg", "innovation"]
      },
      {
        slug: "podiatry",
        spaces: ["podiatry"]
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
