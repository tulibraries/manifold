# frozen_string_literal: true

class WebpagesController < ApplicationController
  include HasCategories
  include HTTParty
  include SerializableRespondTo
  before_action :get_highlights, only: [:home]
  before_action :set_webpage, only: [:show]
  before_action :get_panopto_token, only: [:videos_all, :videos_show]

  def wpvi
  end

  def get_highlights
    @highlights = Highlight.where(promoted: true).take(4)
  end

  def get_panopto_token
    begin
      key = "6e760c72-57bd-4d54-80ea-af1e00d7aed7"
      code = "YXnZpSCFdL8rguhK+kpEDLZobaPuPAqQX7QHt8euKLA="
      auth = {username: key, password: code}
      params =  { "scope" => "api", "grant_type" => "client_credentials" }
      response = HTTParty.post("https://temple.hosted.panopto.com/Panopto/oauth2/connect/token", body: params, basic_auth: auth)
      @access_token = JSON.parse(response.body, symbolize_names: true)[:access_token]
    rescue => e
      e.message
    end
  end

  def panopto_api_call(type, panopto_id)
    api_query = "https://temple.hosted.panopto.com/Panopto/api/v1/#{ type[0] }/#{ panopto_id }"
    api_query += "/#{ type[1] }" if type[1].present?
    request = HTTParty.get(api_query, headers: { "Authorization" => "Bearer #{ @access_token }" })
    JSON.parse(request&.body, symbolize_names: true)
  end

  def videos_all
    @categories = ["recent", "Recent Videos", "98a7258a-f81f-48c1-8541-af1900e5a7af"],
                  ["beyond-the-page", "Beyond the Page", "eba32425-d6bf-4e9c-983f-af1f0128b62b"],
                  ["beyond-the-notes", "Beyond the Notes", "e01cdfba-bc19-4f27-bdc6-af1c00f52773"],
                  ["blockson", "Charles L. Blockson Afro-American Collection", "1aab1d3f-4626-43fd-924d-af1c00f290d5"],
                  ["research-awards", "Livingstone Undergraduate Research Awards", "ad6a8ada-242e-4ddd-8115-af1c00fc3621"],
                  ["lcdss", "Loretta C. Duckworth Scholars Studio", "d320fce9-a51c-4e6f-b85a-af1901046d79"],
                  ["scrc", "Special Collections Research Center", "980a89be-5d85-43e2-b171-af1c00fdd352"]

    @all = []
    @recent = []
    @beyond_page = []
    @beyond_notes = []
    @blockson = []
    @awards = []
    @lcdss = []
    @scrc = []

    @categories.each do |category|
      get_videos = panopto_api_call(["playlists", "sessions"], category[2])   
      get_videos[:Results].each do |video|
        @all << video
        case category[1]
        when "Recent Videos"
          @recent << video
        when "Beyond the Page"
          @beyond_page << video
        when "Beyond the Notes"
          @beyond_notes << video
        when "Charles L. Blockson Afro-American Collection"
          @blockson << video
        when "Livingstone Undergraduate Research Awards"
          @awards << video
        when "Loretta C. Duckworth Scholars Studio"
          @lcdss << video
        when "Special Collections Research Center"
          @scrc << video
        end
      end
    end

    unless @recent.nil?
      @featured_video_id = @recent.first[:Id]
      @featured_video_title = @recent.first[:Name]
    else
      return redirect_to(webpages_videos_all_path, alert: "Unable to retrieve video information.")
    end
  end

  def videos_show
    @displayMode = "show"
    if params[:id].present?
      # binding.pry
      @video = panopto_api_call(["sessions", nil], params[:id])
      unless @video.present?
        return redirect_to(webpages_videos_all_path, alert: "Unable to retrieve video. #{ @video[:Id] }")
      end
      if @video[:Id].nil?
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
