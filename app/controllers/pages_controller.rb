# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_date, :todays_date, :get_highlights, only: [:home, :hsl, :ambler]
  before_action :set_page, only: [:show]

  def get_highlights
    @highlights = Highlight.where(promoted: true).take(4)
  end

  def home
    @events = Event.order(:start_time).take(4)
  end

  def ambler
    @events = Event.where("tags LIKE ?", "Ambler Campus Library").take(4)
  end

  def hsl
    @departments = Group.where(group_type: "Department")
    @ginsburg_hours = LibraryHour.where(location_id: "ginsburg", date: @today).pluck(:hours).first
    @podiatry_hours = LibraryHour.where(location_id: "podiatry", date: @today).pluck(:hours).first
    @events = Event.where("tags LIKE ?", "Health Sciences Libraries").take(4)
  end

  def about
  end

  def visit
  end

  def research
  end

  def show
    render @page.layout.parameterize
  end

  private
    def set_date
      @today = Date.today.strftime("%Y-%m-%d 00:00:00")
    end
    def todays_date
      @todays_date = @today.to_date.strftime("%^A, %^B %d, %Y ")
    end
    def set_page
      @page = Page.find(params[:id])
    end
end
