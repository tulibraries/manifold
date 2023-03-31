# frozen_string_literal: true

class EventsController < ApplicationController
  include SetInstance
  include RedirectLogic
  before_action :set_types
  before_action :set_event, only: [:show]
  before_action :init, only: [:index, :past]
  include EventFilters


  def index
    @snippet = Snippet.find_by(slug: "events-intro-snippet")
    events = Event.is_current.is_displayable
    @featured_events = Event.is_current.is_displayable.where(featured: true).order(:start_time).take(3)
    if params[:type].present? && params[:type].downcase == "workshop"
      @workshops = events.is_workshop
      return_events(@workshops)
    else
      return_events(events)
    end
    @exhibitions = Exhibition.is_current
                              .where(promoted_to_events: true)
                              .order(start_date: :desc, end_date: :desc)
                              .take(5)
    @mailing_list = ExternalLink.find_by(slug: "events-mailing-list")
    @intro = Webpage.find_by(slug: "events-intro")

    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(events) }
    end
  end

  def set_types
    @types = ["digital_scholarship", "health_sciences", "index", "past_events"]
    @type = action_name if @types.include? action_name
  end

  def dss_events
    @type = "digital_scholarship"
    @dss_events = Event.is_current.is_dss_event.is_displayable
    return_events(@dss_events)
    render :search, search: params[:search]
  end

  def hsl_events
    @type = "health_sciences"
    @hsl_events = Event.is_current.is_hsl_event.is_displayable
    return_events(@hsl_events)
    render :search
  end

  def search
    @query = params[:search]
    if @query.present?
      @type == action_name
      events = Event.is_current.is_displayable.search(@query)
      return_events(events)
    end
  end

  def past
    past_events = Event.is_past.is_displayable
    workshops = Event.is_past.is_workshop.is_displayable
    (params[:type].present? && params[:type].downcase == "workshop") ? return_events(workshops) : return_events(past_events)
    @exhibitions = Exhibition.is_past
                              .order(end_date: :desc, start_date: :desc)
                              .take(3)
    @intro = Webpage.find_by(slug: "events-intro")
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(past_events) }
    end
  end

  def past_search
    @query = params[:search]
    events = Event.is_past.is_displayable.search(@query)
    return_events(events)
    render "search"
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
      params[:page].present? ?  params[:page] : 1 
      @events_list = events.page params[:page]
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@event) }
    end
  end

  private
    def init
      @today = Date.current
    end

    def set_event
      @event = find_instance
      @event_url = @event.event_url unless @event.nil?
      return redirect_or_404(@event)
    end
end
