# frozen_string_literal: true

class WebpagesController < ApplicationController
  include HasCategories
  include HTTParty
  include SerializableRespondTo
  before_action :get_highlights, only: [:home]
  before_action :set_webpage, only: [:show]
  before_action :video_init, only: [:videos_all, :videos_show, :videos_list, :videos_search]

  def wpvi
  end

  def get_highlights
    @highlights = Highlight.where(promoted: true).take(4)
  end

  def video_init
    @libraryID = "fd034a20-5fb2-4c61-8269-df7e357e78e1"
    @user = ENV["ENSEMBLE_API_USER"]
    @key = ENV["ENSEMBLE_API_KEY"]
    @basepath = "https://svc.#{@user}:#{@key}@ensemble.temple.edu/api"
    @medialibrary = "/medialibrary/" + @libraryID + "?PageIndex=1&PageSize=1000"
    @categories = ["All Past Programs", "Beyond the Page", "Beyond the Notes", "Charles L. Blockson Collection", "Livingstone Undergraduate Research Awards", "Loretta C. Duckworth Scholars Studio", "Special Collections Research Center", "Temple Alumni"]
    @category = @categories[params[:collection].to_i]
    @all = []
    @beyond_page = []
    @beyond_notes = []
    @blockson = []
    @awards = []
    @lcdss = []
    @scrc = []
    @alumni = []
  end

  def videos_all
    @displayMode = "all"
    api_query = @basepath + "/medialibrary/" + @libraryID + "?PageIndex=1&PageSize=1000"
    ensemble_api(api_query)
    unless @videos.nil?
      @featured_video_id = @videos[:Data].first[:ID]
      @featured_video_title = @videos[:Data].first[:Title]
      @videos[:Data].each do |video|
        unless video[:ThumbnailUrl].include?("Width=240")
          video[:ThumbnailUrl] = video[:ThumbnailUrl][0..-4] + "240"
        end
        @all << video
        tags = video[:Keywords].split(",").each do |tag|
          case tag
          when "Beyond the Page"
            @beyond_page << video
          when "Beyond the Notes"
            @beyond_notes << video
          when "Charles L. Blockson Collection"
            @blockson << video
          when "Livingstone Undergraduate Research Awards"
            @awards << video
          when "Loretta C. Duckworth Scholars Studio"
            @lcdss << video
          when "Special Collections Research Center"
            @scrc << video
          when "Temple Alumni"
            @alumni << video
          end
        end if video[:Keywords].present?
      end
    else
      return redirect_to(webpages_videos_all_path, alert: "Unable to retrieve video information.")
    end
  end

  def videos_show
    @displayMode = "show"
    unless params[:id].nil?
      api_query = @basepath + "/content/" + URI::encode(params[:id])
      ensemble_api(api_query)
      unless @videos.nil?
        @featured_video_id = @videos[:ID]
        @featured_video_title = @videos[:Title]
        @featured_video_description = CGI.unescapeHTML(@videos[:Description]) unless @videos[:Description].nil?
      else
        return redirect_to(webpages_videos_all_path, alert: "Unable to retrieve video.")
      end
      if @featured_video_id.nil?
        return redirect_to(webpages_videos_all_path, alert: "Unable to retrieve video.")
      end
    else
      return redirect_to(webpages_videos_all_path, alert: "You must choose a video to stream.")
    end
  end

  def videos_list
    @category = params[:collection]
    unless @category.nil? || @category.blank? || @category == "0"
      @categoryTitle = @categories[params[:collection].to_i]
      unless @categoryTitle.nil?
        api_query = @basepath + @medialibrary + "&FilterValue=" + URI::encode(@categoryTitle)
      end
    else
      @categoryTitle = "All Past Programs"
      api_query = @basepath + @medialibrary
    end
    ensemble_api(api_query) unless api_query.nil?
    if @videos.nil?
      return redirect_to(webpages_videos_all_path, alert: "Unable to retrieve video list.")
    end
  end

  def videos_search
    if params[:q].blank?
      return redirect_to(webpages_videos_all_path)
    else
      api_query = @basepath + @medialibrary + "&FilterValue=" + URI::encode(params[:q])
      ensemble_api(api_query)
      if @videos.first[1].nil?
        @categoryTitle = "your search for: #{params[:q]} returned 0 results"
      else
        @categoryTitle = "your search for: #{params[:q]} returned #{@videos.first[1].count} results"
      end
    end
  end

  def ensemble_api(api_query)
    begin
      videos = HTTParty.get(api_query)
      @videos = JSON.parse(videos&.body, symbolize_names: true)
    rescue => e
      e.message
    end
  end

  def home
    @todays_hours = LibraryHour.todays_hours_at("charles")
    @header_alert = Alert.where(published: true).find_by(for_header: true)
    @news_items = Highlight.where(promoted: true).take(3)
    @featured_events = Event.where(featured: true).order(:start_time).take(3)
    @cta3 = Category.find_by(slug: "computers-printing-technology")
    @cta4 = Category.find_by(slug: "explore-charles")
  end

  def scrc
    @visit_links = Category.find_by(slug: "scrc-study").items
    @collection_links = Category.find_by(slug: "scrc-collections").items
    @webpage = Webpage.find_by(slug: "scrc-intro")
    @header_alert = Alert.where(published: true).find_by(for_header: true)
  end

  def blockson
    @webpage = Webpage.find_by(slug: "blockson-intro")
    @visit_links = Category.find_by(slug: "blockson-study").items
    @research_links = Category.find_by(slug: "blockson-research").items
    @events = Event.where(["tags LIKE ? and end_time >= ?", "blockson", Time.zone.now]).order(:start_time).take(4)
    @header_alert = Alert.where(published: true).find_by(for_header: true)
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
    @header_alert = Alert.where(published: true).find_by(for_header: true)
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
    @header_alert = Alert.where(published: true).find_by(for_header: true)
  end

  def hsl
    @resource_links = Category.find_by(slug: "hsl-resources").items
    @research_links = Category.find_by(slug: "hsl-research").items
    @visit_links = Category.find_by(slug: "hsl-study").items
    @event_links = Event.where(["tags LIKE ? and end_time >= ?", "%Health Science%", Time.zone.now]).order(:start_time).take(5)
    @study_room = ExternalLink.find_by(slug: "hsl-study-rooms")
    @remote_learning = Webpage.find_by(slug: "online-support")
    @header_alert = Alert.where(published: true).find_by(for_header: true)
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
    @covid_alert = @webpage.covid_alert
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
