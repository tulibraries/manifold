# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_date, :todays_date, :get_highlights, only: [:home, :hsl, :ambler]
  before_action :set_page, only: [:show]
  before_action :navigation_items, only: [:show]

  def get_highlights
    @highlights = Highlight.where(promoted: true).take(4)
  end

  def home
    @events = Event.order(:start_time).take(4)
  end

  def ambler
    @events = Event.where("tags LIKE ?", "Ambler Campus Library").take(4)
  end
  def scrc
    @events = Event.where("tags LIKE ?", "Special Collections Research Center").take(4)
  end
  def blockson
    @events = Event.where("tags LIKE ?", "blockson").take(4)
  end

  def hsl
    @ginsburg_location = Building.find_by(name: "Simmy and Harry Ginsburg Health Sciences Library")
    @podiatry_location = Building.find_by(name: "Charles E. Krausz Library of Podiatric Medicine")
    @visit_links = Category.find_by("upper(name) = ?", "VISIT & STUDY AT THE HEALTH SCIENCES LIBRARIES").items.sort_by { |e| e.label }
    @resource_links = Category.find_by("upper(name) = ?", "HSL RESOURCES AND MEDIA").items.sort_by { |e| e.label }
    @research_links = Category.find_by("upper(name) = ?", "RESEARCH AT THE HEALTH SCIENCES LIBRARIES").items.sort_by { |e| e.label }
    @event_links = Event.where("tags LIKE ?", "%Health Science Libraries%").take(5)
  end

  def about
    @categories = Category.find_by_name("About the Libraries").items.select { |item| item.class == Category }
  end

  def visit
    @categories = Category.find_by_name("Visit the Libraries").items.select { |item| item.class == Category }
  end

  def blogs
    @categories = Category.find_by_name("Blogs & News").items.select { |item| item.class == Category }
  end

  def publications
    @categories = Category.find_by_name("Publications, Reports, & Statistics").items.select { |item| item.class == Category }
  end

  def support
    @categories = Category.find_by_name("Support the Libraries").items.select { |item| item.class == Category }
  end

  def grants
    @categories = Category.find_by_name("Grants, Fellowships, & Competitions").items.select { |item| item.class == Category }
  end

  def policies
    @categories = Category.find_by_name("Policies & Guidelines").items.select { |item| item.class == Category }
  end

  def contact
  end

  def research
    @categories = Category.find_by_name("Research Services").items.select { |item| item.class == Category }
  end

  def index
    @pages = Page.all
    respond_to do |format|
      format.html
      format.json { render json: PageSerializer.new(@pages) }
    end
  end

  def contact
  end

  def show
    @categories = @page.categories
    respond_to do |format|
      # format.html { render @page.layout.parameterize }
      format.html
      format.json { render json: PageSerializer.new(@page) }
    end
  end

  def navigation_items
    @nav_items = []
    @page.categories.each do |cat|
      cat.items.each do |item|
        unless item.id == @page.id
          @nav_items << item
        end
      end
    end
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
