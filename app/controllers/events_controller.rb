# frozen_string_literal: true

class EventsController < ApplicationController
  include SetInstance
  include RedirectLogic
  before_action :set_event, only: [:show]
  before_action :init_current, only: [:index]
  before_action :init_past, only: [:past]
  include EventFilters


  def index
    if params["type"].present? && params["type"].downcase == "workshop"
      @workshops = Event.is_current.is_workshop
      return_events(@workshops) 
    else
      return_events(@all_current_events)
    end
    @exhibitions = Exhibition.is_current
                              .where(promoted_to_events: true)
                              .order(start_date: :desc, end_date: :desc)
                              .take(5)
    @mailing_list = ExternalLink.find_by(slug: "events-mailing-list")
    @intro = Webpage.find_by(slug: "events-intro")

    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@all_current_events) }
    end
  end
  
  def search
    @query = params[:search]
    if @query.present?
      events = Event.is_current.search(@query).order(start_time: :asc)
      return_events(events)
    end
  end

  def past
    workshops = Event.is_past.is_workshop
    (params["type"].present? && params["type"].downcase == "workshops") ? return_events(workshops) : return_events(@all_past_events)
    @exhibitions = Exhibition.is_past
                              .order(end_date: :desc, start_date: :desc)
                              .take(3)
    @intro = Webpage.find_by(slug: "events-intro")
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@all_past_events) }
    end
  end

  def past_search
    # binding.pry
    events = Event.is_past.search(params[:search]).order(start_time: :asc)
    return_events(events)
    render "search"
  end

  def return_events(events)
    @events = []
    if params["date"].present?
      day_start = Date.parse(params[:date]).beginning_of_day
      day_end = Date.parse(params[:date]).end_of_day
      @events = dates_list(events.having("start_time > ?", day_start)
                      .merge(events.having("start_time < ?", day_end))
                      .order(:start_time))
      if action_name == "past"
        events_list = Event.is_past.where(id: @events.map(&:id)).order(start_time: :desc)
      else
        events_list = Event.is_current.where(id: @events.map(&:id)).order(:start_time)
      end
      @events_list = events_list.page params[:page]
    else
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
  def init_current
    @all_current_events = Event.is_current.group(:id).order(start_time: :asc)
    @all_past_events = Event.is_past.group(:id).order(start_time: :asc)
    @featured_events = Event.where(featured: true).order(:start_time).take(3)
    @today = Date.current
  end

  def init_past
    @all_past_events = Event.is_past.group(:id).order(start_time: :asc)
    @today = Date.current
  end

    def set_event
      @event = find_instance
      @event_url = @event.event_url unless @event.nil?
      return redirect_or_404(@event)
    end
end
