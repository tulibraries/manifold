# frozen_string_literal: true

class WebpagesController < ApplicationController
  include HasCategories
  include HTTParty
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
    @categories = ["All Past Programs", "Beyond the Page", "Beyond the Notes", "Charles L. Blockson Collection", "Livingstone Undergraduate Research Awards", "Loretta C. Duckworth Scholars Studio", "Special Collections Research Center"]
    @category = @categories[params[:collection].to_i]
    @all = []
    @beyond_page = []
    @beyond_notes = []
    @blockson = []
    @awards = []
    @lcdss = []
    @scrc = []
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
          end
        end
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
    api_query = @basepath + @medialibrary + "&FilterValue=" + URI::encode(params[:q])
    ensemble_api(api_query)
    unless @videos.nil?
      @categoryTitle = 'you searched for: "' + params[:q] + '"'
    else
      return redirect_to(webpages_videos_all_path, alert: "Unable to retrieve videos.")
    end
  end

  def ensemble_api(api_query)
    videos = HTTParty.get(api_query)
    begin
      @videos = JSON.parse(videos&.body, symbolize_names: true)
    rescue => e
      e.message
    end
  end

  def home
    @research_help = Service.find_by(slug: "sme")
    @print_my_paper = Service.find_by(slug: "printing")
    @book_study_room = Space.find_by(slug: "study-rooms-small")
    @locations = Building.find_by(slug: "ambler")
    @todays_hours = LibraryHour.todays_hours_at("ask_a_librarian")
    @libguides = ExternalLink.find_by(slug: "libguides")
    @explore_charles = Category.find_by(slug: "explore-charles")
    @remote_student_support = Webpage.find_by(slug: "remote-student-support")
    @remote_faculty_support = Webpage.find_by(slug: "remote-faculty-support")
    @explore_online_collections = Webpage.find_by(slug: "explore-online-collections")
  end

  def scrc
    @scrc_location = Space.find_by(slug: "scrc-room")
    @reading_room = Space.find_by(slug: "scrc-reading-room")
    @visit = Category.find_by(slug: "scrc-study")
    @visit_links = Category.find_by(slug: "scrc-study").items
    @collections = Category.find_by(slug: "scrc-collections")
    @collection_links = Category.find_by(slug: "scrc-collections").items
    @webpage = Webpage.find_by(slug: "scrc-intro")
  end

  def blockson
    @webpage = Webpage.find_by(slug: "blockson-intro")
    @visit = Category.find_by(slug: "blockson-study")
    @visit_links = Category.find_by(slug: "blockson-study").items
    @research = Category.find_by(slug: "blockson-research")
    @research_links = Category.find_by(slug: "blockson-research").items
    @events = Event.where(["tags LIKE ? and end_time >= ?", "blockson", Time.zone.now]).order(:start_time).take(4)
    @building = Building.find_by(slug: "blockson")
  end

  def tudsc
    @makerspace_location = Space.find_by(slug: "makerspace")
    @vr_location = Space.find_by(slug: "immersive-lab")
    @innovation_location = Space.find_by(slug: "innovation-sandbox")
    @visit = Category.find_by(slug: "lcdss-study")
    unless @visit.nil?
      @visit_links = @visit.items
    end
    @research = Category.find_by(slug: "lcdss-research")
    unless @research.nil?
      @research_links = @research.items
    end
    @event_links = Event.where(["tags LIKE ? and end_time >= ?", "%Digital Scholarship%", Time.zone.now]).order(:start_time).take(5)
    @blog = Blog.find_by(slug: "lcdss-blog")
    @blog_posts = @blog.blog_posts.sort_by { |post| post.publication_date }.reverse.take(5)
    @info = Space.find_by(slug: "lcdss")
    @webpage = Webpage.find_by(slug: "lcdss-intro")
  end

  def hsl
    @hsl_giving = Policy.find_by(slug: "hsl-giving")
    @ginsburg_location = Building.find_by(slug: "ginsburg")
    @podiatry_location = Building.find_by(slug: "podiatry")
    @visit = Category.find_by(slug: "hsl-study")
    @visit_links = Category.find_by(slug: "hsl-study").items
    @resources = Category.find_by(slug: "hsl-resources")
    @resource_links = Category.find_by(slug: "hsl-resources").items
    @research = Category.find_by(slug: "hsl-research")
    @research_links = Category.find_by(slug: "hsl-research").items
    @event_links = Event.where(["tags LIKE ? and end_time >= ?", "%Health Science%", Time.zone.now]).order(:start_time).take(5)
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
    @webpages = Webpage.all
    respond_to do |format|
      format.html
      format.json { render json: WebpageSerializer.new(@webpages) }
    end
  end

  def contact
    @fcn_link = Webpage.find_by(slug: "numbers")
    @libanswers = ExternalLink.find_by(slug: "libanswers")
    @suggestions = ExternalLink.find_by(slug: "suggestions")
  end

  def show
    @categories = @webpage.categories
    respond_to do |format|
      # format.html { render @webpage.layout.parameterize }
      format.html
      format.json { render json: WebpageSerializer.new(@webpage) }
    end
  end

  private
    def set_webpage
      unless params[:id].nil?
        @webpage = Webpage.friendly.find(params[:id])
      else
        @webpage = Webpage.find_by(slug: action_name)
      end
      @categories = @webpage.categories
    end
end
