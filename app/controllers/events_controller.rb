# frozen_string_literal: true

class EventsController < ApplicationController
  include SetInstance
  include RedirectLogic
  before_action :set_type
  before_action :set_event, only: [:show]
  before_action :init, only: [:index, :past_events]
  include EventFilters


  def index
    @snippet = Snippet.find_by(slug: "events-intro-snippet")
    events = Event.is_current.is_displayable
    return_event_listings(EventListing.feed.current.exhibitions_first)

    exhibition = Exhibition.is_current.find_by(highlighted: true)
    num_featured_events = exhibition ? 2 : 3
    featured_events = Event.is_current.is_displayable.where(featured: true).order(:start_time).take(num_featured_events)
    @featured_events = [exhibition, *featured_events].compact

    @mailing_list = ExternalLink.find_by(slug: "events-mailing-list")
    @intro = Webpage.find_by(slug: "events-intro")

    if params[:type].present? && params[:type].downcase == "events-only"
      events = Event.is_current.is_displayable.is_not_workshop
      return_events(events)
      render :search
    end


    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(events) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@event) }
    end
  end

  def search
    @query = params[:search]
    if @query.present?
      return_event_listings(EventListing.feed.current.matching(@query).exhibitions_first)
    end
  end

  def past_search
    @type = "past_search"
    @query = params[:search]
    return_event_listings(EventListing.feed.past.matching(@query).most_recent_first)
    render :search
  end

  def past_events
    @type = "past_events"
    events = Event.is_past.is_displayable
    return_event_listings(EventListing.feed.past.most_recent_first)
    workshops = Event.is_past.is_workshop.is_displayable
    @intro = Webpage.find_by(slug: "events-intro")

    if params[:type].present? && params[:type].downcase == "events-only"
      events = Event.is_past.is_displayable.is_not_workshop
      return_events(events)
      render :search
    end

    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(past_events) }
    end
  end

  def workshops
    events = Event.is_current.is_workshop.is_displayable
    return_events(events)
    render :search
  end

  def past_workshops
    @type = "past_workshops"
    events = Event.is_past.is_workshop.is_displayable
    return_events(events)
    render :search
  end

  def return_events(events)
    @events = []
    if params[:date].present?
      day_start = Date.parse(params[:date]).beginning_of_day
      day_end = Date.parse(params[:date]).end_of_day
      events = events.group(:id)
      @events = dates_list(events.having("start_time >= ?", day_start)
                      .and(events.having("start_time <= ?", day_end))
                      .order(:start_time))
      events_list = Event.where(id: @events.map(&:id))
      @events_list = events_list.page params[:page]
    else
      params[:page].presence || 1
      @events_list = events.page params[:page]
    end
  end

  def return_event_listings(listings)
    @events_list = if params[:date].present?
      listings.on_date(Date.parse(params[:date]))
                   else
                     listings
    end
    @events_list = @events_list.page(params[:page])
    preload_event_listing_sources(@events_list)
  end

  def dss_events
    @dss_events = Event.is_current.is_dss_event.is_displayable
    return_events(@dss_events)
    render :search
  end

  def hsl_events
    @hsl_events = Event.is_current.is_hsl_event.is_displayable
    return_events(@hsl_events)
    render :search
  end

  def featured_exhibit
    @exhibit = Exhibition.is_current
  end

  private
    def preload_event_listing_sources(listings)
      listings_by_type = listings.to_a.group_by(&:source_type)
      events = Event.where(id: listings_by_type.fetch("event", []).map(&:source_id)).index_by(&:id)
      exhibitions = Exhibition.where(id: listings_by_type.fetch("exhibition", []).map(&:source_id)).index_by(&:id)

      listings_by_type.fetch("event", []).each { |listing| listing.source = events[listing.source_id] }
      listings_by_type.fetch("exhibition", []).each { |listing| listing.source = exhibitions[listing.source_id] }
    end

    def init
      @today = Date.current
    end

    def set_event
      @event = find_instance
      @event = nil if @event&.suppress
      @event_url = @event.event_url unless @event.nil?
      return redirect_or_404(@event)
    end

    def set_type
      @types = ["dss_events", "hsl_events", "index", "past", "workshops"]
      @type = action_name if @types.include? action_name
    end
end
