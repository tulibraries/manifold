# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: [:show]
  before_action :init, only: [:index, :past]
  include EventFilters


  def index
    events = @all_events.having("start_time >= ?", @today).order(:start_time)
    @events = return_events(events)
    @mailing_list = ExternalLink.find_by_slug("events-mailing-list")
    @intro = Webpage.find_by_slug("events-intro")
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@events) }
    end
  end

  def past
    events = @all_events.having("start_time < ?", @today).order(start_time: :desc)
    @events = return_events(events)
    @intro = Webpage.find_by_slug("events-intro")
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@events) }
    end
  end

  def return_events(events)
    @events = []
    if params.has_key?("type")
      @type_events = events.having("event_type LIKE ?", "%#{params[:type]}%").order(:start_time)
    end
    if params.has_key?("location")
      @loc_events = events.where(building: params[:location]).or(
        events.where(external_building: params[:location])).order(
          start_time: :desc)
    end

    unless @type_events.nil? && @loc_events.nil?
      unless @type_events.nil?
        @events += @type_events
      end
      unless @loc_events.nil?
        @events += @loc_events
      end
    end

    @event_types = all_types(events)
    unless @events.empty?
      @event_types = types_list(@events)
    end

    @event_locations = locations_list(events)
    unless @events.empty?
      @event_locations = locations_list(@events)
    end

    unless @events.blank?
      unless action_name == "past"
        events_list = Event.where(id: @events.map(&:id)).order(:start_time)
      else
        events_list = Event.where(id: @events.map(&:id)).order(start_time: :desc)
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
    def init
      @all_events = Event.group(:id)
      @exhibitions = Exhibition.where(promoted_to_events: true)
      @today = Date.today
    end

    def set_event
      @event = Event.find(params[:id])
    end
end
