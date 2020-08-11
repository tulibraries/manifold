# frozen_string_literal: true

class EventsController < ApplicationController
  include SetInstance
  include RedirectLogic
  before_action :set_event, only: [:show]
  before_action :init, only: [:index, :past]
  include EventFilters


  def index
    events = @all_events.having("start_time >= ?", @today).order(start_time: :asc)
    @events = return_events(events)
    @mailing_list = ExternalLink.find_by(slug: "events-mailing-list")
    @intro = Webpage.find_by(slug: "events-intro")
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@all_events) }
    end
  end

  def past
    events = @all_events.having("start_time < ?", @today).order(start_time: :desc)
    @events = return_events(events)
    @intro = Webpage.find_by(slug: "events-intro")
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@all_events) }
    end
  end

  def return_events(events)
    @events = []
    if params["type"].present?
      @events = events.having("event_type LIKE ?", "%#{params[:type]}%").order(:start_time)
    end

    if params["date"].present?
      day_start = Date.parse(params[:date]).beginning_of_day
      day_end = Date.parse(params[:date]).end_of_day
      @events = events.having("start_time > ?", day_start)
                      .merge(events.having("start_time < ?", day_end))
                      .order(:start_time)
    end

    @event_types = all_types(events)
    @event_dates = dates_list(events)

    unless @events.empty?
      @event_dates = dates_list(@events)
    end
    #
    if @events.present?
      unless action_name == "past"
        events_list = Event.where(id: @events.map(&:id)).order(:start_time)
      else
        events_list = Event.where(id: @events.map(&:id)).order(start_time: :desc)
      end
      @events_list = events_list.page params[:page]
    else
      if params[:date].present?
        @events_list = @events.page params[:page]
      else
        @events_list = events.page params[:page]
      end
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
      @all_events = Event.group(:id)
      @featured_events = Event.where(featured: true).order(:start_time).take(3)
      @exhibitions = Exhibition.where(promoted_to_events: true)
      @today = Date.current
    end

    def set_event
      @event = find_instance
      return redirect_or_404 unless @event
      @event_url = @event.event_url
    end
end
