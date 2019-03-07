# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: [:show]
  before_action :init, only: [:index, :past]

  def index
    @events = @all_events.having("start_time >= ?", @today).order(:start_time)
    @events = return_events(@events)
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@events) }
    end
  end

  def past
    @events = @all_events.having("start_time < ?", @today).order(start_time: :desc)
    @events = return_events(@events)
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@events) }
    end
  end

  def return_events(events)
    if params.has_key?("type")
      @events = @events.having("event_type LIKE ?", "%#{params[:type]}%").order(:start_time)
    elsif params.has_key?("location")
      @events = @events.having("building_id LIKE ?", "%#{params[:location]}%").or(@events.having("external_building LIKE ?", "%#{params[:location]}%")).order(start_time: :desc)
    end
    @event_types = return_types(events)
    @event_spaces = return_locations(events)
    @events_list = @events.page params[:page]
  end

  def return_types(events)
    @event_types = events.pluck(:event_type)
    @types = []
    @event_types.each do |type|
      types = type.split(",")
      types.each do |t|
        unless t.nil? || t.blank?
          @types.push(t)
        else
          @types.push("Uncategorized")
        end
      end
    end
    @event_types = @types.collect(&:strip).flatten.uniq.sort
  end

  def return_locations(events)
    locations = []
    internal_locations = events.pluck(:building_id)
    external_locations = events.pluck(:external_building)
    all_locations = internal_locations.concat(external_locations)

    events.each do |event|
      unless event.building_id.nil? && event.external_building.nil?
        unless event.building_id.nil?
          locations.push([event.building_id, event.building_name(event)])
        else
          locations.push([nil, event.building_name(event)])
        end
      end
    end

    @event_locations = locations.compact.uniq
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
