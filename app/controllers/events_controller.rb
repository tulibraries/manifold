# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: [:show]

  def index
    @all_events = Event.group(:id)
    @exhibitions = Exhibition.where(promoted_to_events: true)
    @today = Date.today

    unless params[:id] == "past"
      @events = @all_events.having("start_time >= ?", @today).order(:start_time)
      @event_types = return_types(@events)
      @event_spaces = return_locations(@events)
      @events = return_events(@events)
    else
      @events = @all_events.having("start_time < ?", @today).order(start_time: :desc)
      @event_types = return_types(@events)
      @event_spaces = return_locations(@events)
      @events = return_events(@events)
    end
    
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@event) }
    end
  end

  def return_events(events)
    if params.has_key?("type")
      @events = @events.having("event_type LIKE ?", "%#{params[:type]}%").order(:start_time)
    elsif params.has_key?("location")
      @events = @events.having("external_space LIKE ?", "%#{params[:location]}%").or(@events.having("external_space LIKE ?", "%#{params[:location]}%")).order(start_time: :desc)
    end
    @events_list = @events.page params[:page]
  end

  def return_types(events)
    @event_types = @events.pluck(:event_type)
    @types = []
    @event_types.each do |type|
      types = type.split(",")
      types.each do |t|
        unless t.nil?
          @types.push(t)
        end
      end
    end
    @event_types = @types.collect(&:strip).flatten.uniq.sort
  end

  def return_locations(events)
    @event_spaces = @events.pluck(:space, :external_space).flatten
    @spaces = []
    @event_spaces.each do |space|
      unless space.nil?
        spaces = space.split(",")
        spaces.each do |t|
          unless t.nil? || t == "space" || t == "external_space" || t == I18n.t("manifold.default.event.space")
            @spaces.push(t)
          end
        end
      end
    end
    @event_spaces = @spaces.collect(&:strip).flatten.uniq.sort
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: EventSerializer.new(@event) }
    end
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end
end
