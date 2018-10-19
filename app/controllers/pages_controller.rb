# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_date, only: [:about_ambler]
  
  def home
  end

  def get_highlights
    @highlights = Highlight.where(promoted: true).take(4)
  end

  def ambler
  end

  def index
    @buildings = Building.all
  end

  def show
    @todays_hours = LibraryHours.where(location_id: @building.hours, date: @today)
  end

  private
    def set_date
      @today = Date.today.strftime("%Y-%m-%d 00:00:00")
    end
end
