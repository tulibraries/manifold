# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_date, :todays_date, :get_highlights, only: [:home, :hsl, :ambler]
  before_action :set_page, only: [:show, :charles]
  before_action :navigation_items, only: [:show, :charles]

  def get_highlights
    @highlights = Highlight.where(promoted: true).take(4)
  end

  def charles
    @page = Page.find_by_slug("charles")
    @images = ["24_7.jpg", "atrium.jpg", "charles.jpg", "class.jpg", "classroom.jpg",
                "digital-scholars.jpg", "entry-plaza.jpg", "event-space.jpg",
                "exhibition.jpg", "frozen-garden.jpg", "grove.jpg", "liacouras.jpg",
                "north-reading-room.jpg", "oculus.jpg", "one-stop.jpg", "quiet-reading-room.jpg",
                "reading-room.jpg", "scrc.jpg", "stacks.jpg", "writing-center.jpg",
                "floorplan1.jpg", "floorplan2.jpg", "floorplan3.jpg", "floorplan4.jpg" ]
  end

  def home
    @research_help = Service.find_by_slug("sme")
    @print_my_paper = Service.find_by_slug("printing")
    @book_study_room = Space.find_by_slug("study-rooms-small")
    @explore_charles = Page.find_by_slug("charles")
    if @explore_charles.nil?
      @explore_charles = Service.find_by_slug("charles-in-charge")
    end
    @locations = Building.find_by_slug("ambler")
    @todays_hours = LibraryHour.find_by(location_id: "charles", date: @today)
  end

  def scrc
    @scrc_location = Space.find_by_slug("scrc-room")
    @visit_links = Category.find_by_slug("scrc-study").items.sort_by { |e| e.label }
    @collection_links = Category.find_by_slug("scrc-collections").items.sort_by { |e| e.label }
    @page = Page.find_by_slug("scrc-intro")
  end

  def blockson
    @page = Page.find_by_slug("blockson-intro")
    @visit_links = Category.find_by_slug("blockson-study").items.sort_by { |e| e.label }
    @research_links = Category.find_by_slug("blockson-research").items.sort_by { |e| e.label }
    @events = Event.where("tags LIKE ?", "blockson").take(4)
    @building = Building.find_by_slug("blockson")
  end

  def tudsc
    @makerspace_location = Space.find_by_slug("makerspace")
    @vr_location = Space.find_by_slug("immersive-lab")
    @innovation_location = Space.find_by_slug("innovation-sandbox")
    visit_links = Category.find_by_slug("lcdss-study")
    unless visit_links.nil?
      @visit_links = visit_links.items.sort_by { |e| e.label }
    end
    research_links = Category.find_by_slug("lcdss-research")
    unless research_links.nil?
      @research_links = research_links.items.sort_by { |e| e.label }
    end
    @event_links = Event.where("tags LIKE ?", "%Digital Scholarship%").take(5)
    @blog = Blog.find_by_slug("lcdss-blog")
    @blog_posts = @blog.blog_posts.take(5)
    @info = Space.find_by_slug("lcdss")
    @page = Page.find_by_slug("lcdss-intro")
  end

  def hsl
    @ginsburg_location = Building.find_by_slug("ginsburg")
    @podiatry_location = Building.find_by_slug("podiatry")
    @visit_links = Category.find_by_slug("hsl-study").items.sort_by { |e| e.label }
    @resource_links = Category.find_by_slug("hsl-resources").items.sort_by { |e| e.label }
    @research_links = Category.find_by_slug("hsl-research").items.sort_by { |e| e.label }
    @event_links = Event.where("tags LIKE ?", "%Health Science%").take(5)
  end

  def about
    @categories = Category.find_by_slug("about-page").items.select { |item| item.class == Category }
  end

  def visit
    @categories = Category.find_by_slug("visit").items.select { |item| item.class == Category }
  end

  def blogs
    @categories = Category.find_by_slug("news").items.select { |item| item.class == Category }
  end

  def publications
    @categories = Category.find_by_slug("publications").items.select { |item| item.class == Category }
  end

  def support
    @categories = Category.find_by_slug("giving").items.select { |item| item.class == Category }
  end

  def grants
    @categories = Category.find_by_slug("grants").items.select { |item| item.class == Category }
  end

  def policies
    @categories = Category.find_by_slug("policies").items.select { |item| item.class == Category }
  end

  def research
    @categories = Category.find_by_slug("research-services").items.select { |item| item.class == Category }
  end

  def navigation_items
    @nav_items = []
    binding.pry
    @page.categories.each do |cat|
      cat.items(exclude: [:category]).sort_by { |e| e.label }.each do |item|
        unless item.id == @page.id
          @nav_items << item
        end
      end
    end
  end

  def index
    @pages = Page.all
    respond_to do |format|
      format.html
      format.json { render json: PageSerializer.new(@pages) }
    end
  end

  def contact
    @fcn_link = Page.find_by_slug("numbers")
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
      @today = Date.today.strftime("%Y-%m-%d 04:00:00")
    end
    def todays_date
      @todays_date = @today.to_date.strftime("%^A, %^B %d, %Y ")
    end
    def set_page
      unless params[:id].nil?
        @page = Page.find(params[:id])
      else
        @page = Page.find_by_slug(action_name)
      end
      @categories = @page.categories
    end
end
