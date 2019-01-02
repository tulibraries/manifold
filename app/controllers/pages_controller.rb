# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_date, :todays_date, :get_highlights, only: [:home, :hsl, :ambler]

  def get_highlights
    @highlights = Highlight.where(promoted: true).take(4)
  end

  def home
    @events = Event.take(4)
  end

  def ambler
    @events = Event.take(4)
  end

  def hsl
    @departments = Group.where(group_type: "Department")
    @ginsburg_hours = LibraryHours.where(location_id: "ginsburg", date: @today).pluck(:hours).first
    @podiatry_hours = LibraryHours.where(location_id: "podiatry", date: @today).pluck(:hours).first
    @events = Event.take(4)
  end

  private
    def set_date
      @today = Date.today.strftime("%Y-%m-%d 00:00:00")
    end
    def todays_date
      @todays_date = @today.to_date.strftime("%^A, %^B %d, %Y ")
    end
end
