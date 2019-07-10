# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: [:show]
  before_action :init, only: [:index, :past]
  include EventFilters


  def index
    events = @all_events.having("start_time >= ?", @today).order(:start_time)
    @events = return_events(events)
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@events) }
    end
  end

  def past
    events = @all_events.having("start_time < ?", @today).order(start_time: :desc)
    @events = return_events(events)
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@events) }
    end
  end

  def return_events(events)
    if params.has_key?("type")
      @events = events.having("event_type LIKE ?", "%#{params[:type]}%").order(:start_time)
    elsif params.has_key?("location")
      @events = events.where(building: params[:location]).or(
        events.where(external_building: params[:location])).order(
          start_time: :desc)
    end
    @event_types = types_list(events)
    @event_locations = locations_list(events)
    unless @events.nil?
      @events_list = @events.page params[:page]
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
