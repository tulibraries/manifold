# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_date, :todays_date, :get_highlights, only: [:home, :hsl, :ambler]
  before_action :set_page, only: [:show]
  before_action :navigation_items, only: [:show]

  def get_highlights
    @highlights = Highlight.where(promoted: true).take(4)
  end

  def home
    @research_help = Service.find_by_title("Talk to a librarian or subject matter expert")
    @print_my_paper = Service.find_by_title("Print, photocopy and scan")
    @book_study_room = Space.find_by_name("Charles Library small group study rooms")
    @explore_charles = Category.find_by_name("Introducing Charles Library")
    @todays_hours = LibraryHour.find_by(location_id: "charles", date: @today)
  end

  def ambler
    @events = Event.where("tags LIKE ?", "Ambler Campus Library").take(4)
  end
  def scrc
    @scrc_location = Space.find_by(name: "SCRC Reading Room")
    @visit_links = Category.find_by("upper(name) = ?", "VISIT & STUDY AT THE SPECIAL COLLECTIONS RESEARCH CENTER").items.sort_by { |e| e.label }
    @collection_links = Collection.all.sort_by { |e| e.label }
    @page = Page.find_by_title("SCRC homepage")
  end
  def blockson
    @events = Event.where("tags LIKE ?", "blockson").take(4)
  end

  def tudsc
    @makerspace_location = Space.where("name LIKE ?", "Makerspace").first
    @vr_location = Space.where("name LIKE ?", "%Immersive%").first
    @innovation_location = Space.where("name LIKE ?", "%Innovation%").first
    visit_links = Category.where("upper(name) LIKE ?", "VISIT%SCHOLARS% STUDIO%")
    unless visit_links.nil?
      @visit_links = visit_links.first.items.sort_by { |e| e.label }
    end
    research_links = Category.where("upper(name) LIKE ?", "%RESEARCH%SCHOLARS%STUDIO%")
    unless visit_links.nil?
      @research_links = research_links.first.items.sort_by { |e| e.label }
    end
    @event_links = Event.where("tags LIKE ?", "%Digital Scholarship%").take(5)
    @blog = Blog.where("title = ?", "Digital Scholarship Center").first
    @blog_posts = @blog.blog_posts.take(5)
    @info = Space.where("name LIKE ?", "%Scholars Studio").first
    @page = Page.find_by_title("DSC homepage")
  end

  def hsl
    @ginsburg_location = Building.where("name LIKE ?", "%Health Sciences Library").first
    @podiatry_location = Building.where("name LIKE ?", "%Podiatric%").first
    @visit_links = Category.find_by("upper(name) = ?", "VISIT & STUDY AT THE HEALTH SCIENCES LIBRARIES").items.sort_by { |e| e.label }
    @resource_links = Category.find_by("upper(name) = ?", "HSL RESOURCES AND MEDIA").items.sort_by { |e| e.label }
    @research_links = Category.find_by("upper(name) = ?", "RESEARCH AT THE HEALTH SCIENCES LIBRARIES").items.sort_by { |e| e.label }
    @event_links = Event.where("tags LIKE ?", "%Health Science%").take(5)
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
      @today = Date.today.strftime("%Y-%m-%d 04:00:00")
    end
    def todays_date
      @todays_date = @today.to_date.strftime("%^A, %^B %d, %Y ")
    end
    def set_page
      @page = Page.find(params[:id])
    end
end
