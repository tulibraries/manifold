# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: [:show]
  before_action :init, only: [:index, :past]
  include EventFilters


  def index
    events = @all_events.having("start_time >= ?", @today).order(:start_time)
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
      if params["location"].present?
        @types = events.where("event_type LIKE ?", "%#{params[:type]}%").order(:start_time)
        @internals = events.where(building: params[:location]).order(:start_time)
        @externals = events.where(external_building: params[:location]).order(:start_time)
        @externals += @internals
        if @externals.nil?
          @events = @types
        else
          @events = @types.to_a & @externals.to_a
        end
      else
        @events = events.where("event_type LIKE ?", "%#{params[:type]}%").order(:start_time)
      end
    end

    if params["location"].present?
      if params["type"].present?
        @types = events.where("event_type LIKE ?", "%#{params[:type]}%").order(:start_time)
        @internals = events.where(building: params[:location]).order(:start_time)
        @externals = events.where(external_building: params[:location]).order(:start_time)
        @externals += @internals
        if @externals.nil?
          @events = @types
        else
          @events = @types.to_a & @externals.to_a
        end
      else
        @events = events.where(building: params[:location]).or(events.where(external_building: params[:location])).order(:start_time)
      end
    end

    unless @events.empty?
      @event_types = types_list(@events)
    else
      @event_types = all_types(events)
    end

    @event_locations = locations_list(events)
    unless @events.empty?
      @event_locations = locations_list(@events)
    end

    if @events.present?
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
      @today = Time.zone.today
    end

    def set_event
      if Event.find_by(slug: params[:id])
        @event = Event.friendly.find(params[:id])
      else
        @event = Event.find_by(id: params[:id])
      end
      return redirect_or_404 unless @event
      @event_url = @event.event_url
    end
end
