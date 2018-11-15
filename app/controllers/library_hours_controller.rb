# frozen_string_literal: true

class LibraryHoursController < ApplicationController
  before_action :get_locations, only: [:index, :show]
  before_action :set_location, only: [:show]
  before_action :set_dates, only: [:index, :show]

  def index
    @buildings = [
      {
        slug: "paley",
        spaces: [ 
                  "paley",
                  "media",
                  "doc_del",
                  "ref_desk",
                  "v_ref",
                  "thinktank",
                  "scrc",
                  "dsc",
                  "guest_computers"
                ]
      },
      {
        slug: "ginsburg",
        spaces: ["ginsburg","innovation"]
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
        space = [building.values.first, LibraryHours.where(location_id: space, date: @sunday..@saturday)]
      end
    end
  end

  def set_dates
    @today = Date.today
    @year =  @today.year
    @week =  params[:week].nil? ? Date.today.cweek : params[:week].to_i
    @first_week = LibraryHours.where(location_id: "paley").first.date.to_date.cweek
    @first_year = LibraryHours.where(location_id: "paley").first.date.to_date.year
    @last_week = LibraryHours.where(location_id: "paley").last.date.to_date.cweek
    @last_year = LibraryHours.where(location_id: "paley").last.date.to_date.year

    @next_week = @week+1
    @prev_week = @week-1

    @next_year = params[:nyear].nil? ? @year : params[:nyear].to_i
    @prev_year = params[:pyear].nil? ? @year : params[:pyear].to_i

    if @week == 52
      @next_week = 1
      @next_year = @next_year + 1
      @year = @year + 1

    end

    if @week == 1
      @prev_week = 52 
      @prev_year = @prev_year - 1
    end

    @sunday = Date.commercial(@year, @week) - 1
    @saturday = Date.commercial(@year, @week) + 6
    # binding.pry
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
    @location = LibraryHours.distinct.pluck(:location_id)
  end

  def build_hours_data_structure(input)
    input.map do |building|
      building[:spaces].map! do |space|
        {slug: space, hours: LibraryHours.where(location_id: space, date: @sunday..@saturday)}
      end
      building
    end
  end
end
