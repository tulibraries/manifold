# frozen_string_literal: true

class WebpagesController < ApplicationController
  include HasCategories
  include SerializableRespondTo
  before_action :set_webpage, only: [:show]

  def wpvi
  end

  def videos_all
    videos = Panopto::VideoDistributor.call(type: "all")
    render(Panopto::PastEventsComponent.new(videos:))
  end

  def videos_list
    videos = Panopto::CollectionLookup.call(params[:collection])

    if videos.present?
      render(Panopto::PastEventsCollectionComponent.new(videos:))
    else
      redirect_to(webpages_videos_all_path, notice: "You must choose a video collection.")
    end
  end

  def video_show
    video = Panopto::VideoLookup.call(params[:id])

    if video.present?
      render(Panopto::PastEventsVideoComponent.new(video:))
    else
      video_error
    end
  end

  def video_error
    return redirect_to(webpages_videos_all_path, notice: "You must choose a video to stream.")
  end

  def videos_search
    videos = Panopto::VideoSearch.call(params[:q])

    if videos.present?
      render(Panopto::PastEventsSearchComponent.new(videos:))
    elsif params[:q].blank?
      redirect_to(webpages_videos_all_path, notice: "You must choose a term to search for.")
    end
  end

  def etextbooks
    snippet = helpers.etextbooks_snippet
    etexts = Google::SheetsConnector.call(feature: "etexts")
    if etexts.present?
      render(Google::EtextbooksComponent.new(etexts:, title: snippet[:title],
                                                      description: snippet[:description],
                                                      column: params[:column],
                                                      direction: params[:direction]))
    else
      redirect_to(root_path, notice: "The requested page is not available")
    end
  end

  def home
    home_page = Webpages::HomePage.call

    @todays_hours = home_page[:todays_hours]
    @highlights = home_page[:highlights]
    @featured_events = home_page[:featured_events]
    @digcols = home_page[:digcols]
    @cta3 = home_page[:cta3]
    @cta4 = home_page[:cta4]
  end

  def hours
  end

  def scrc
    scrc_page = Webpages::ScrcPage.call

    @visit_links = scrc_page[:visit_links]
    @collection_links = scrc_page[:collection_links]
    @webpage = scrc_page[:webpage]
    @intro = scrc_page[:intro]
  end

  def scrc_planyourvisit
    @categories = [Category.find_by(slug: "scrc-study")]
    @space = Space.find_by(slug: "scrc-reading-room")
  end

  def blockson
    blockson_page = Webpages::BlocksonPage.call

    @webpage = blockson_page[:webpage]
    @visit_links = blockson_page[:visit_links]
    @research_links = blockson_page[:research_links]
    @events = blockson_page[:events]
    @tours = blockson_page[:tours]
    @tour_links = blockson_page[:tour_links]
  end

  def tudsc
    lcdss_page = Webpages::LcdssPage.call

    @webpage = lcdss_page[:webpage]
    @visit_links = lcdss_page[:visit_links]
    @research_links = lcdss_page[:research_links]
    @event_links = lcdss_page[:event_links]
    @blog = lcdss_page[:blog]
    @blog_posts = lcdss_page[:blog_posts]
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
    @categories = Webpages::CategoryPage.call("about-page")
  end

  def visit
    @categories = Webpages::CategoryPage.call("visit")
  end

  def blogs
    @categories = Webpages::CategoryPage.call("news")
  end

  def publications
    @categories = Webpages::CategoryPage.call("publications")
  end

  def support
    @categories = Webpages::CategoryPage.call("giving")
  end

  def grants
    @categories = Webpages::CategoryPage.call("grants")
  end

  def policies
    @categories = Webpages::CategoryPage.call("policies")
  end

  def research
    @categories = Webpages::CategoryPage.call("research-services")
  end

  def list_item(category)
    cat_link(category, @webpage)
  end

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

  helper_method :list_item

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
      super + [:fileabilities_attributes, :draft_description, :publish]
    end
end
