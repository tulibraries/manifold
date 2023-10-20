# frozen_string_literal: true

class WebpagesController < ApplicationController
  include HasCategories
  include SerializableRespondTo
  before_action :get_highlights, only: [:home]
  before_action :set_webpage, only: [:show]

  def wpvi
  end

  def get_highlights
    @highlights = Highlight.where(promoted: true).take(4)
  end

  def videos_all
    videos = Panopto::VideoDistributor.call(type: "all")
    render(Panopto::PastEventsComponent.new(videos:))
  end

  def videos_list
    if params[:collection].present?
      videos = Panopto::VideoDistributor.call(type: "collection", collection: params[:collection])
      render(Panopto::PastEventsCollectionComponent.new(videos:))
    else
      videos_all
    end
  end

  def video_show
    if params[:id].present?
      video = Panopto::VideoDistributor.call(type: "show", video_id: params[:id])
      render(Panopto::PastEventsVideoComponent.new(video:))
    else
      return redirect_to(webpages_videos_all_path, alert: "You must choose a video to stream.")
    end
  end

  def videos_search
    if params[:q].present?
      videos = Panopto::VideoDistributor.call(type: "search", query: params[:q])
      render(Panopto::PastEventsSearchComponent.new(videos:))
    else
      return redirect_to(webpages_videos_all_path, alert: "You must choose a term to search for.")
    end
  end

  def home
    @todays_hours = LibraryHour.todays_hours_at("charles")
    @highlights = Highlight.with_image.where(promoted: true).take(3)
    @featured_events = Event.where(featured: true).order(:start_time).take(3)
    @cta3 = Category.find_by(slug: "computers-printing-technology")
    @cta4 = Category.find_by(slug: "explore-charles")
  end

  def scrc
    @visit_links = Category.find_by(slug: "scrc-study").items
    @collection_links = Category.find_by(slug: "scrc-collections").items
    @webpage = Webpage.find_by(slug: "scrc-intro")
    @intro = Snippet.find_by(slug: "scrc-homepage-intro")
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
    @event_links = Event.is_current.where("lower(tags) LIKE ?", "%digital scholarship%").order(:start_time).take(5)
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
    @event_links = Event.is_current.is_hsl_event.take(5)
    @study_room = ExternalLink.find_by(slug: "hsl-study-rooms")
    @remote_learning = Webpage.find_by(slug: "online-support")
  end

  def news
    @blogs = Blog.all
    @blogposts = BlogPost.all.order(:created_at).reverse.take(3)
    @highlights = Highlight.with_image.where(promoted: true).take(3)
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
    @header_alert = @webpage.covid_alert
    @featured = @webpage.featured_item
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

    def permitted_attributes
      super + [:draft_description, :publish]
    end
end
