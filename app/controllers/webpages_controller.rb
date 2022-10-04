# frozen_string_literal: true

class WebpagesController < ApplicationController
  include HasCategories
  include SerializableRespondTo
  before_action :get_highlights, only: [:home]
  before_action :set_webpage, only: [:show]
  before_action :set_playlists, only: [:videos_all, :videos_list]

  def wpvi
  end

  def get_highlights
    @highlights = Highlight.where(promoted: true).take(4)
  end

  def set_playlists
    @categories = ["recent", "Recent Videos", "98a7258a-f81f-48c1-8541-af1900e5a7af"],
                  ["beyond-the-page", "Beyond the Page", "eba32425-d6bf-4e9c-983f-af1f0128b62b"],
                  ["beyond-the-notes", "Beyond the Notes", "e01cdfba-bc19-4f27-bdc6-af1c00f52773"],
                  ["blockson", "Charles L. Blockson Afro-American Collection", "1aab1d3f-4626-43fd-924d-af1c00f290d5"],
                  ["research-awards", "Livingstone Undergraduate Research Awards", "ad6a8ada-242e-4ddd-8115-af1c00fc3621"],
                  ["lcdss", "Loretta C. Duckworth Scholars Studio", "d320fce9-a51c-4e6f-b85a-af1901046d79"],
                  ["scrc", "Special Collections Research Center", "980a89be-5d85-43e2-b171-af1c00fdd352"]
  end

  def videos_all
    @playlist_title = @categories.first.second
    @playlist_id = @categories.first.third
  end

  def videos_list
    @category = params[:collection]
    if @category.present?
      playlist = @categories.each.select { |m| m if m[0] == @category }.flatten
      @playlist_title = playlist.second
      @playlist_id = playlist.third
    else
      @playlist_title = @categories.first.second
      @playlist_id = @categories.first.third
    end
  end

  def home
    @todays_hours = LibraryHour.todays_hours_at("charles")
    @news_items = Highlight.where(promoted: true).take(3)
    @featured_events = Event.where(featured: true).order(:start_time).take(3)
    @cta3 = Category.find_by(slug: "computers-printing-technology")
    @cta4 = Category.find_by(slug: "explore-charles")
  end

  def scrc
    @visit_links = Category.find_by(slug: "scrc-study").items
    @collection_links = Category.find_by(slug: "scrc-collections").items
    @webpage = Webpage.find_by(slug: "scrc-intro")
  end

  def blockson
    @webpage = Webpage.find_by(slug: "blockson-intro")
    @visit_links = Category.find_by(slug: "blockson-study").items
    @research_links = Category.find_by(slug: "blockson-research").items
    @events = Event.where(["tags LIKE ? and end_time >= ?", "blockson", Time.zone.now]).order(:start_time).take(4)
    @tours = Category.find_by(name: "360&deg; Virtual Exhibits")
    @tour_links = @tours.items if @tours.present?
  end

  def tudsc
    @webpage = Webpage.find_by(slug: "lcdss-intro")
    @visit_links =  Category.find_by(slug: "lcdss-study").items || nil
    @research_links = Category.find_by(slug: "lcdss-research").items || nil
    @event_links = Event.where(["tags LIKE ? and end_time >= ?", "%Digital Scholarship%", Time.zone.now]).order(:start_time).take(5)
    @blog = Blog.find_by(slug: "lcdss-blog")
    @blog_posts = @blog.blog_posts.sort_by { |post| post.publication_date }.reverse.take(5)
  end

  def scop
    @webpage = Webpage.find_by(slug: "scop-intro")
    @description = @webpage.description if @webpage.present?
    @pub_services = Category.find_by(slug: "publishing-services")
    @pub_services_links = @pub_services.items if @pub_services.present?
    @scholar_share = Category.find_by(slug: "tuscholarshare")
    @scholar_share_links = @scholar_share.items if @scholar_share.present?
    @event_links = Event.where(tags: "SCOP")
                        .where(end_time: Time.zone.now..Float::INFINITY)
                        .order(:start_time)
                        .take(5)
    @blog = Blog.find_by(slug: "scholarly-communications-at-temple")
    @blog_posts = @blog.blog_posts.sort_by { |post| post.publication_date }.reverse.take(5) if @blog.present?
  end

  def hsl
    @resource_links = Category.find_by(slug: "hsl-resources").items
    @research_links = Category.find_by(slug: "hsl-research").items
    @visit_links = Category.find_by(slug: "hsl-study").items
    @event_links = Event.where(["tags LIKE ? and end_time >= ?", "%Health Science%", Time.zone.now]).order(:start_time).take(5)
    @study_room = ExternalLink.find_by(slug: "hsl-study-rooms")
    @remote_learning = Webpage.find_by(slug: "online-support")
  end

  def about
    @categories = Category.find_by(slug: "about-page").items.select { |item| item.class == Category }
  end

  def visit
    @categories = Category.find_by(slug: "visit").items.select { |item| item.class == Category }
  end

  def blogs
    @categories = Category.find_by(slug: "news").items.select { |item| item.class == Category }
  end

  def publications
    @categories = Category.find_by(slug: "publications").items.select { |item| item.class == Category }
  end

  def support
    @categories = Category.find_by(slug: "giving").items.select { |item| item.class == Category }
  end

  def grants
    @categories = Category.find_by(slug: "grants").items.select { |item| item.class == Category }
  end

  def policies
    @categories = Category.find_by(slug: "policies").items.select { |item| item.class == Category }
  end

  def research
    @categories = Category.find_by(slug: "research-services").items.select { |item| item.class == Category }
  end

  def list_item(category)
    cat_link(category, @webpage)
  end
  helper_method :list_item

  def index
    serializable_index
  end

  def contact
  end

  def show
    @categories = @webpage.categories
    serializable_show
  end

  private
    def set_webpage
      unless params[:id].nil?
        @webpage = Webpage.friendly.find(params[:id])
      else
        @webpage = Webpage.find_by(slug: action_name)
      end
      @categories = @webpage.categories unless @webpage.nil?
    end
end
